# timings:
# 1m serial
# 2m20 multiproc N=2
# 5m50 multiproc N=1

import logging
import os
import subprocess
import multiprocessing
import tempfile
from argparse import Namespace
from pathlib import Path
import shutil
import secrets
import time
import pickle
import copy

from .error import EvalError, RepoNotFoundError
from .manifest import Repo, load_manifest, update_lock_file, update_eval_errors, update_eval_errors_lock_file
from .path import ROOT, EVALREPO_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH, LOCK_PATH, MANIFEST_PATH, PREFETCH_CACHE_PATH, nixpkgs_path
from .prefetch import prefetch
from .process import prctl_set_pdeathsig

logging.basicConfig(
    format="%(asctime)s %(filename)s:%(lineno)d %(levelname)s: %(message)s",
    level=logging.INFO,
)
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
            preexec_fn=lambda: prctl_set_pdeathsig(),
        )
        try:
            (stdout, _stderr) = proc.communicate(timeout=15)
        except subprocess.TimeoutExpired:
            proc.kill()
            raise EvalError(f"evaluation for {repo.name} timed out of after 15 seconds")
        if proc.returncode != 0:
            # normalize tempdir path
            stdout = stdout.replace(str(d), "/tmp/nur-update")
            # print only new errors. old errors are stored in EVAL_ERRORS_PATH
            print(stdout)
            raise EvalError(f"Repository {repo.name} does not evaluate:\n$ {' '.join(cmd)}", stdout)


def update2(repo: Repo, prefetch_result) -> Repo:
    _cached_repo, new_version, repo_path = prefetch_result

    # workaround for cached prefetch. cache key is only repo.name
    if new_version == repo.locked_version:
        repo_path = None

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


def prefetch_worker(args):
    repo, prefetch_cache = args
    result, error = None, None
    t1 = time.time()
    if repo.name in prefetch_cache:
        entry = prefetch_cache[repo.name]
        expire = 60 * 60 # 60 minutes
        time_expired = time.time() - expire
        if entry.get("time") > time_expired:
            # not expired -> cache hit
            result = entry.get("result")
            error = entry.get("error")
    if result == None and error == None:
        # cache miss
        try:
            # TODO capture output of subprocess
            result = prefetch(repo)
        except Exception as err:
            error = err
    t2 = time.time()
    dt = t2 - t1
    #if dt > 0.05:
    #    # read cache: 0.002
    #    # fetch: 1.0
    #logger.info(f"Repository {repo.name}: Prefetch done after {dt:.2f} seconds")
    return repo, result, error


def update_command(args: Namespace) -> None:
    logging.basicConfig(level=logging.INFO)

    manifest = load_manifest(MANIFEST_PATH, LOCK_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH)

    prefetch_cache_file = PREFETCH_CACHE_PATH

    # readonly cache: we read every key only once per run
    readonly_prefetch_cache = {}
    try:
        logger.info(f"reading cache file {prefetch_cache_file} ...")
        with open(prefetch_cache_file, "rb") as f:
            readonly_prefetch_cache = pickle.load(f)
            logger.info(f"readonly cache keys: {readonly_prefetch_cache.keys()}")
            expire = 60 * 60 # 60 minutes
            time_expired = time.time() - expire
            # fix: RuntimeError: dictionary changed size during iteration
            #for key in cache:
            for key in list(readonly_prefetch_cache.keys()):
                entry = readonly_prefetch_cache[key]
                if entry.get("time") < time_expired:
                    del readonly_prefetch_cache[key]
            logger.info(f"reading cache file {prefetch_cache_file} done")
    except (IOError, ValueError) as err:
        # no such file, etc
        logger.info(f"reading cache file {prefetch_cache_file} failed: {err}")
        pass

    # writable cache
    prefetch_cache = copy.deepcopy(readonly_prefetch_cache)
    logger.info(f"cache keys: {prefetch_cache.keys()}")

    prefetch_repos = manifest.repos
    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")
    if debug_nur_repo:
        prefetch_repos = list(filter(lambda repo: repo.name == debug_nur_repo, prefetch_repos))

    # keep 1 cpu for nix-env, 1 cpu for system
    #prefetch_pool_size = max(1, os.cpu_count() - 2)
    prefetch_pool_size = 1
    logger.info(f"Starting prefetch with {prefetch_pool_size} workers")
    prefetch_pool = multiprocessing.Pool(processes=prefetch_pool_size)

    prefetch_args = zip(prefetch_repos, [readonly_prefetch_cache for _ in prefetch_repos])

    for repo, prefetch_result, prefetch_error in prefetch_pool.imap_unordered(prefetch_worker, prefetch_args):
        if repo.name not in prefetch_cache:
            # write cache
            logger.info(f"Repository {repo.name}: Writing prefetch cache")
            prefetch_cache[repo.name] = {
                "time": time.time(),
                "value": prefetch_result,
                "error": prefetch_error,
            }
            #logger.info(f"cache keys: {prefetch_cache.keys()}")
            with open(prefetch_cache_file, "wb") as f:
                pickle.dump(prefetch_cache, f)

        if prefetch_error:
            # TODO cache prefetch errors?
            logger.exception(f"Repository {repo.name}: Prefetch failed: {prefetch_error}")
            continue
        try:
            update2(repo, prefetch_result)
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
        # this is a prefetch error
        #except RepoNotFoundError as err:
        #    # Do not print stack traces
        #    logger.error(f"repository {repo.name} failed to prefetch: {err}")
        except Exception:
            # for non-evaluation errors we want the stack trace
            logger.exception(f"Failed to update repository {repo.name}")

        # TODO update only the current repo
        update_lock_file(manifest.repos, LOCK_PATH)
        update_eval_errors_lock_file(manifest.repos, EVAL_ERRORS_LOCK_PATH)
        update_eval_errors(manifest.repos, EVAL_ERRORS_PATH)
