import logging
import os
import subprocess
import tempfile
from argparse import Namespace
from pathlib import Path
import shutil
import secrets

from .error import EvalError
from .manifest import Repo, load_manifest, update_lock_file, update_eval_errors, update_eval_errors_lock_file
from .path import ROOT, EVALREPO_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH, LOCK_PATH, MANIFEST_PATH, nixpkgs_path
from .prefetch import prefetch

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
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, # combine stderr and stdout
            encoding="utf8",
        )
        try:
            (stdout, _stderr) = proc.communicate(timeout=15)
        except subprocess.TimeoutExpired:
            raise EvalError(f"evaluation for {repo.name} timed out of after 15 seconds")
        if proc.returncode != 0:
            # normalize tempdir path
            stdout = stdout.replace(str(d), "/tmp/nur-update")
            # print only new errors. old errors are stored in EVAL_ERRORS_PATH
            print(stdout)
            raise EvalError(f"Repository {repo.name} does not evaluate:\n$ {' '.join(cmd)}", stdout)


def update(repo: Repo) -> Repo:
    repo, new_version, repo_path = prefetch(repo)
    repo.new_version = new_version

    if repo.eval_error_version == new_version:
        eval_error_path = os.path.relpath(EVAL_ERRORS_PATH.joinpath(f"{repo.name}.txt"), ROOT)
        raise EvalError(f"Repository {repo.name} did not evaluate in a previous run with version {repo.eval_error_version}. See error message in {eval_error_path}", repo.eval_error_text)

    if not repo_path:
        logger.info(f"Repository {repo.name}: Skipped eval. No change in locked_version {repo.locked_version}")
        return repo

    eval_repo(repo, repo_path)

    if repo.locked_version != new_version:
        logger.info(f"Repository {repo.name}: Done eval. Updated locked_version from {repo.locked_version} to {new_version}")
        repo.locked_version = new_version

    return repo


def update_command(args: Namespace) -> None:
    logging.basicConfig(level=logging.INFO)

    manifest = load_manifest(MANIFEST_PATH, LOCK_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH)

    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")

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
        except Exception:
            # for non-evaluation errors we want the stack trace
            logger.exception(f"Failed to update repository {repo.name}")

        # TODO update only the current repo
        update_lock_file(manifest.repos, LOCK_PATH)
        update_eval_errors_lock_file(manifest.repos, EVAL_ERRORS_LOCK_PATH)
        update_eval_errors(manifest.repos, EVAL_ERRORS_PATH)
