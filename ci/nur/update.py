import logging
import os
import subprocess
import tempfile
from argparse import Namespace
from pathlib import Path
import shutil
import secrets
import time
import cProfile, pstats, io

from .error import EvalError, RepoNotFoundError
from .manifest import Repo, load_manifest, update_lock_file, update_eval_errors, update_eval_errors_lock_file
from .path import ROOT, EVALREPO_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH, LOCK_PATH, MANIFEST_PATH, nixpkgs_path
from .prefetch import prefetch
from .process import prctl_set_pdeathsig

logger = logging.getLogger(__name__)


def eval_repo(repo: Repo, repo_path: Path) -> None:
    temp_suffix = secrets.token_hex(nbytes=16)
    with tempfile.TemporaryDirectory(temp_suffix) as d:
        eval_path = Path(d).joinpath("default.nix")
        evalrepo_path = Path(d).joinpath("evalRepo.nix")
        shutil.copyfile(EVALREPO_PATH, evalrepo_path)
        with open(eval_path, "w") as f:
            f.write(
                f"""
                    with import <nixpkgs> {{}};
                    import {evalrepo_path} {{
                        name = "{repo.name}";
                        url = "{repo.url}";
                        src = {repo_path.joinpath(repo.file)};
                        inherit pkgs lib;
                    }}
                """
            )

        # fmt: off
        cmd = [
            "nix-env",
            "-f", str(eval_path),
            "-qa", "*",
            "--meta",
            "--xml",
            "--allowed-uris", "https://static.rust-lang.org",
            "--option", "restrict-eval", "true",
            "--option", "allow-import-from-derivation", "true",
            "--drv-path",
            "--show-trace",
            "-I", f"nixpkgs={nixpkgs_path()}",
            "-I", str(repo_path),
            "-I", str(eval_path),
            "-I", str(evalrepo_path),
        ]
        # fmt: on

        logger.info(f"Evaluating repository {repo.name}")
        env = dict(PATH=os.environ["PATH"], NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM="1")
        proc = subprocess.Popen(
            cmd,
            env=env,
            stdout=subprocess.DEVNULL, # ignore stdout <items>...</items>
            stderr=subprocess.PIPE, # combine stderr and stdout
            encoding="utf8",
            preexec_fn=lambda: prctl_set_pdeathsig(),
        )
        try:
            (_stdout, stderr) = proc.communicate(timeout=15)
        except subprocess.TimeoutExpired:
            proc.kill()
            raise EvalError(f"evaluation for {repo.name} timed out of after 15 seconds")
        if proc.returncode != 0:
            # normalize tempdir path
            stderr = stderr.replace(str(d), "/tmp/nur-update")
            # print only new errors. old errors are stored in EVAL_ERRORS_PATH
            print(stderr)
            raise EvalError(f"Repository {repo.name} does not evaluate:\n$ {' '.join(cmd)}", stderr)


def update(repo: Repo) -> Repo:
    t1 = time.time()
    _cached_repo, new_version, repo_path = prefetch(repo)
    # workaround for cached prefetch. cache key is only repo.name
    if new_version == repo.locked_version:
        repo_path = None
    t2 = time.time()
    dt = t2 - t1
    if dt > 0.05:
        # read cache: 0.002
        # fetch: 1.0
        logger.info(f"Repository {repo.name}: prefetch: dt = {dt}")
    repo.new_version = new_version

    if repo.eval_error_version == new_version:
        eval_error_path = os.path.relpath(EVAL_ERRORS_PATH.joinpath(f"{repo.name}.txt"), ROOT)
        raise EvalError(f"Repository {repo.name} did not evaluate in a previous run with version {repo.eval_error_version}. See error message in {eval_error_path}", repo.eval_error_text)

    if not repo_path:
        logger.info(f"Repository {repo.name}: Skipped eval. No change in locked_version {repo.locked_version}")
        return repo

    eval_repo(repo, repo_path)

    if repo.locked_version != new_version:
        logger.info(f"Repository {repo.name}: Done eval. Updated locked_version to {new_version}")
        repo.locked_version = new_version

    return repo


def update_command_inner(args: Namespace) -> None:
    logging.basicConfig(level=logging.INFO)

    manifest = load_manifest(MANIFEST_PATH, LOCK_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH)

    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")

    logger.info(f"Looping repos")

    for repo in manifest.repos:
        if debug_nur_repo and repo.name != debug_nur_repo:
            continue
        try:
            update(repo)
            repo.eval_error_version = None
            repo.eval_error_text = None
        except EvalError as err:
            if repo.locked_version is None:
                # likely a repository added in a pull request, make it fatal then
                logger.error(
                    f"repository {repo.name} failed to evaluate: {err}. This repo is not yet in our lock file!!!!"
                )
                raise
            # Do not print stack traces
            logger.error(f"repository {repo.name} failed to evaluate: {err}")
            repo.eval_error_version = repo.new_version
            repo.eval_error_text = err.stdout
        except RepoNotFoundError as err:
            # Do not print stack traces
            logger.error(f"repository {repo.name} failed to prefetch: {err}")
        except Exception:
            # for non-evaluation errors we want the stack trace
            logger.exception(f"Failed to update repository {repo.name}")

        # TODO update only the current repo
        update_lock_file(manifest.repos, LOCK_PATH)
        update_eval_errors_lock_file(manifest.repos, EVAL_ERRORS_LOCK_PATH)
        update_eval_errors(manifest.repos, EVAL_ERRORS_PATH)


def update_command(args: Namespace) -> None:
    do_profile = True

    if not do_profile:
        return update_command_inner(args)

    pr = cProfile.Profile()
    pr.enable()
    update_command_inner(args)
    pr.disable()
    s = io.StringIO()
    ps = pstats.Stats(pr, stream=s).sort_stats(pstats.SortKey.CUMULATIVE)
    ps.print_stats()
    print(s.getvalue())
