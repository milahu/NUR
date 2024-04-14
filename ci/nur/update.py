import logging
import os
import subprocess
import tempfile
from tempfile import TemporaryDirectory
from argparse import Namespace
from pathlib import Path
import shutil
import secrets
import time
import cProfile, pstats, io
from distutils.dir_util import copy_tree
import shlex

shlex_join_bak = shlex.join
def shlex_join(args):
    return shlex_join_bak(map(str, args))
shlex.join = shlex_join

from .error import EvalError, RepoNotFoundError
from .manifest import Repo, load_manifest, update_lock_file, update_eval_errors, update_eval_errors_lock_file
from .path import ROOT_PATH, EVALREPO_PATH, EVAL_RESULTS_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH, LOCK_PATH, MANIFEST_PATH, nixpkgs_path, COMBINED_REPOS_PATH
from .prefetch import prefetch, update_version_github_repos, update_version_git_repos
from .process import prctl_set_pdeathsig
from . import combine
from .combine import capture_check_call

logger = logging.getLogger(__name__)


#def eval_repo(repo: Repo, repo_path: Path) -> None:
def eval_repo(repo: Repo, repo_path: Path) -> str:
    #logger.debug(f"eval_repo: repo_path = {repo_path}")
    # TODO use nix.py bindings for eval https://github.com/NixOS/nix/pull/7735
    # TODO(milahu) why?
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
            #"--xml", # TODO which is faster? xml or json
            "--json",
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

        #eval_timeout = 15
        eval_timeout = 60

        logger.info(f"Evaluating repository {repo.name}")
        env = dict(PATH=os.environ["PATH"], NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM="1")
        proc = subprocess.Popen(
            cmd,
            env=env,
            #stdout=subprocess.DEVNULL, # ignore stdout <items>...</items>
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf8",
            preexec_fn=lambda: prctl_set_pdeathsig(),
        )
        try:
            stdout, stderr = proc.communicate(timeout=eval_timeout)
        except subprocess.TimeoutExpired:
            proc.kill()
            # pass second argument to EvalError, to cache the error in eval-errors/
            msg = f"evaluation timed out of after 15 seconds"
            raise EvalError(msg, f"nur.update: {msg}")
        if proc.returncode != 0:
            # normalize tempdir path
            stderr = stderr.replace(str(d), "/tmp/nur-update")
            # no. errors are too verbose.
            # print only the main_err_line and write full errors to nur-eval-errors/
            # print only new errors. old errors are stored in EVAL_ERRORS_PATH
            #print(stderr)
            raise EvalError(f"Repository {repo.name} does not evaluate:\n$ {' '.join(cmd)}", stderr)
        return stdout


def update(repo: Repo) -> Repo:

    force_eval = False

    if os.environ.get("NUR_FORCE_EVAL") == "1":
        force_eval = True

    eval_result_path = EVAL_RESULTS_PATH.joinpath(f"{repo.name}.json")
    eval_error_path = EVAL_ERRORS_PATH.joinpath(f"{repo.name}.txt")
    if not eval_result_path.exists() and not eval_error_path.exists():
        force_eval = True

    _cached_repo, new_version, repo_path = prefetch(repo, force=force_eval)

    #logger.debug(f"new_version.date = {new_version.date}")

    # workaround for cached prefetch. cache key is only repo.name
    if not force_eval and new_version == repo.locked_version:
        repo_path = None

    repo.new_version = new_version

    """
    logger.debug(f"repo.locked_version     = {repo.locked_version}")
    logger.debug(f"repo.eval_error_version = {repo.eval_error_version}")
    logger.debug(f"repo.new_version        = {repo.new_version}")
    """

    if repo.eval_error_version == new_version:
        eval_error_path = os.path.relpath(EVAL_ERRORS_PATH.joinpath(f"{repo.name}.txt"), ROOT_PATH)
        #raise EvalError(f"Repository {repo.name} did not evaluate in a previous run with version {repo.eval_error_version}. See error message in {eval_error_path}", repo.eval_error_text)
        #raise EvalError(f"Eval failed before at {repo.eval_error_version}. See {eval_error_path}", repo.eval_error_text)
        #logger.debug(f"Eval failed before, see {eval_error_path}")
        raise EvalError(f"Eval failed before, see {eval_error_path}", repo.eval_error_text)

    if not repo_path:
        #logger.debug(f"Repository {repo.name}: Skipped eval. No change in version {repo.locked_version}")
        return repo

    '''
    # update repo source in nur-combined
    # but do not-yet commit the update
    from . import combine
    # based on combine.commit_repo
    path = Path(COMBINED_REPOS_PATH)
    repo_path = path.joinpath(repo.name).resolve()
    tmp: Optional[TemporaryDirectory] = TemporaryDirectory(prefix=str(repo_path.parent))
    assert tmp is not None
    try:
        copy_tree(combine.repo_source(repo.name), tmp.name, preserve_symlinks=1)
        shutil.rmtree(repo_path, ignore_errors=True)
        os.rename(tmp.name, repo_path)
        tmp = None
    finally:
        if tmp is not None:
            tmp.cleanup()
    #with chdir(str(path)):
    #    combine.commit_files([str(repo_path)], message)
    # TODO
    # git -C COMBINED_REPOS_PATH status
    # git -C COMBINED_REPOS_PATH add repo.name
    # git -C COMBINED_REPOS_PATH status
    # git -C COMBINED_REPOS_PATH commit -m ...
    '''

    t1 = time.time()
    try:
        # TODO merge ci/nur/index.py into here
        repo.eval_result_packages_json = eval_repo(repo, repo_path)
    except Exception:
        t2 = time.time()
        repo.eval_time = t2 - t1
        raise
    t2 = time.time()
    repo.eval_time = t2 - t1

    repo.eval_repo_path = repo_path

    # TODO store repo.eval_time in nur-eval-times, similar to nur-eval-errors
    # or join these into nur-eval-results
    # or store repo.eval_time in packages.json (ci/nur/index.py)

    if repo.locked_version != new_version:
        logger.info(f"Repository {repo.name}: Done eval. Updated version from {repo.locked_version} to {new_version}")
        repo.locked_version = new_version

    return repo



def check_bin_dependencies(bin_list):
    for bin in bin_list:
        if shutil.which(bin) != None:
            continue
        raise Exception(f"missing binary: {bin}")



import asyncio
import aiohttp



def update_command_inner(args: Namespace) -> None:

    t1_update = time.time()

    check_bin_dependencies([
        "git",
        "nix",
        "nix-prefetch-git",
        "nix-prefetch-url",
        "rsync",
    ])

    manifest = load_manifest(MANIFEST_PATH, LOCK_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH)

    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")

    total_eval_time = 0
    total_fetch_time = 0

    # no. this would remove repos from repos.json
    """
    if debug_nur_repo:
        def filter_fn(repo):
            return repo.name == debug_nur_repo
        manifest.repos = list(filter(filter_fn, manifest.repos))
    """

    if debug_nur_repo:
        logger.info(f"Updating 1 repos")
    else:
        logger.info(f"Updating {len(manifest.repos)} repos")

    # currently, 225 of 246 repos are github repos = 90%
    t1 = time.time()

    def filter_github_repos(repo):
        return (
            repo.url.geturl().startswith("https://github.com/")
        )

    def filter_git_repos(repo):
        return (
            not repo.url.geturl().startswith("https://github.com/")
        )

    async def async_fetcher():
        async with aiohttp.ClientSession() as aiohttp_session:
            await asyncio.gather(*map(asyncio.create_task, [
                update_version_github_repos(manifest.repos, aiohttp_session, filter_github_repos),
                # 30 git repos: 1.5 versus 30 seconds
                update_version_git_repos(manifest.repos, aiohttp_session, filter_git_repos),
            ]))

    loop = asyncio.new_event_loop()
    loop.run_until_complete(async_fetcher())

    t2 = time.time()
    dt = t2 - t1
    total_fetch_time += dt

    combined_repos = combine.load_combined_repos(COMBINED_REPOS_PATH)
    combined_repos_path = Path(COMBINED_REPOS_PATH).joinpath("repos")
    os.makedirs(combined_repos_path, exist_ok=True)

    for repo in manifest.repos:

        if debug_nur_repo and repo.name != debug_nur_repo:
            continue

        try:
            update(repo)
            repo.eval_error_version = None
            repo.eval_error_text = None

        except EvalError as err:
            err.stdout = err.stdout.replace("\n       ", "\n") # remove indent
            err_lines = err.stdout.strip().split("\n")
            main_err_line = next((x for x in err_lines if x.startswith("error: ")), None)
            if main_err_line == None:
                main_err_line = err.stdout
            if repo.locked_version is None:
                # likely a repository added in a pull request, make it fatal then
                if not str(err).startswith("Eval failed before"):
                    logger.error(
                        f"repository {repo.name} failed to evaluate: {str(err)}. {main_err_line}. This repo is not yet in our lock file!!!!"
                    )
                raise
            # Do not print stack traces
            if not str(err).startswith("Eval failed before"):
                logger.error(f"repository {repo.name} failed to evaluate: {str(err)}. {main_err_line}")
            repo.eval_error_version = repo.new_version
            repo.eval_error_text = err.stdout
        except RepoNotFoundError as err:
            # Do not print stack traces
            logger.error(f"repository {repo.name} failed to prefetch: {err}")
        except Exception:
            # for non-evaluation errors we want the stack trace
            # example: NIX_PATH is unset
            logger.exception(f"Failed to update repository {repo.name}")

        total_eval_time += repo.eval_time
        total_fetch_time += repo.fetch_time

        if repo.eval_result_packages_json:
          # eval was successful

          # update this repo in nur-combined

          combined_repo = None
          if repo.name in combined_repos:
              combined_repo = combined_repos[repo.name]

          args = ["git", "-C", COMBINED_REPOS_PATH, "status", "--porcelain"]
          prc, out, err = capture_check_call(args)
          if out.strip() != "":
              logger.info(f"cleaning dirty git repo: {COMBINED_REPOS_PATH}")
              args = ["git", "-C", COMBINED_REPOS_PATH, "clean", "-fdx"]
              prc, out, err = capture_check_call(args)

          # based on combine.commit_repo
          #repo_path = path.joinpath("repos", repo.name).resolve()
          repo_path = COMBINED_REPOS_PATH.joinpath("repos", repo.name).resolve()
          logger.debug(f"replacing {repo.eval_repo_path} to {repo_path}")

          '''
          tmp: Optional[TemporaryDirectory] = TemporaryDirectory(prefix=str(repo_path.parent))
          assert tmp is not None
          try:
              #copy_tree(combine.repo_source(repo.name), tmp.name, preserve_symlinks=1)
              # FIXME too verbose
              #copy_tree(repo.eval_repo_path, tmp.name, preserve_symlinks=1)
              # no. this would preserve the read-only permissions from nix store
              #shutil.copytree(repo.eval_repo_path, tmp.name, symlinks=True, dirs_exist_ok=True)


              shutil.rmtree(repo_path, ignore_errors=True)
              os.rename(tmp.name, repo_path)
              tmp = None
          finally:
              if tmp is not None:
                  tmp.cleanup()
          #with chdir(str(path)):
          #    combine.commit_files([str(repo_path)], message)
          '''

          # # rsync --recursive --links --executability --delete
          args = [
              "rsync",
              "--recursive",
              "--links", # preserve symlinks
              "--chmod=+w", # make files writable - nix store is read-only
              "--executability", # preserve the executable bit of permissions
              "--delete", # remove extra files in dst
              str(repo.eval_repo_path) + "/",
              str(repo_path) + "/",
          ]
          #logger.debug("running: " + shlex.join(args))
          subprocess.run(args, check=True, timeout=120)

          args = ["git", "-C", COMBINED_REPOS_PATH, "add", f"repos/{repo.name}"]
          #logger.debug("running: " + shlex.join(args))
          prc, out, err = capture_check_call(args)

          args = ["git", "-C", COMBINED_REPOS_PATH, "status", "--porcelain"]
          #logger.debug("running: " + shlex.join(args))
          prc, out, err = capture_check_call(args)

          if out.strip() != "":

              # repo has changed

              new_rev = repo.locked_version.rev
              message = None

              if combined_repo is None:
                  message = f"{repo.name}: init at {new_rev}"
                  #repo = commit_repo(repo, message, path)
                  #return repo

              else:
                  assert combined_repo.locked_version is not None
                  old_rev = combined_repo.locked_version.rev

                  if combined_repo.locked_version != repo.locked_version:
                      if new_rev != old_rev:
                          message = f"{repo.name}: {old_rev[:10]} -> {new_rev[:10]}"
                      else:
                          message = f"{repo.name}: update"

              if message:
                  args = ["git", "-C", COMBINED_REPOS_PATH, "commit", "-m", message]
                  #logger.debug("running: " + shlex.join(args))
                  prc, out, err = capture_check_call(args)

                  args = ["git", "-C", COMBINED_REPOS_PATH, "rev-parse", "HEAD"]
                  #logger.debug("running: " + shlex.join(args))
                  prc, out, err = capture_check_call(args)
                  repo.nur_combined_rev = out.strip()

          if repo.nur_combined_rev == None:

              args = ["git", "-C", COMBINED_REPOS_PATH, "log", "-n1", "--format=%H", "--", f"repos/{repo.name}"]
              #logger.debug("running: " + shlex.join(args))
              prc, out, err = capture_check_call(args)
              repo.nur_combined_rev = out.strip()

          # if repo.nur_combined_rev == None:
          #     TODO ?

          # FIXME use non-zero fetch_time from last eval
          #if repo.fetch_time == 0.0:

          eval_result_path = EVAL_RESULTS_PATH.joinpath(f"{repo.name}.json")
          import json
          def round_float(f):
              return round(f * 1000) / 1000
          eval_result_packages = json.loads(repo.eval_result_packages_json)
          # normalize positions
          position_prefix = str(repo.eval_repo_path) + "/"
          for key in eval_result_packages:
              pkg = eval_result_packages[key]
              if not "meta" in pkg:
                  continue
              if not "position" in pkg["meta"]:
                  continue
              pos = pkg["meta"]["position"]
              if not pos.startswith(position_prefix):
                  continue
              pkg["meta"]["position"] = pos[len(position_prefix):]
          eval_result = {
              "name": repo.name,
              "fetch_time": round_float(repo.fetch_time),
              "eval_time": round_float(repo.eval_time),
              "source": repo.locked_version.as_json(),
              "source_storepath": str(repo.eval_repo_path),
              "nur_combined_rev": repo.nur_combined_rev,
              "packages": eval_result_packages,
          }
          #logger.debug(f"writing {eval_result_path}")
          with open(eval_result_path, "w") as f:
              #json.dump(eval_result, f) # too verbose
              # write compact json
              json.dump(eval_result, f, indent=0, separators=(',', ':')) # only newlines
              # no. this looks ugly in github diff
              #json.dump(eval_result, f, indent=None, separators=(',', ':')) # no whitespace
          # TODO git add
          # git -C nur-eval-results add 0x4A6F.json
          # git -C nur-eval-results add .

    # write after every repo: 150s
    # write once: 100s
    # TODO write on KeyboardInterrupt so we can stop and resume
    update_lock_file(manifest.repos, LOCK_PATH)
    update_eval_errors_lock_file(manifest.repos, EVAL_ERRORS_LOCK_PATH)
    update_eval_errors(manifest.repos, EVAL_ERRORS_PATH)

    # TODO? join nur-eval-results/*.json into packages.json

    t2_update = time.time()
    dt_update = t2_update - t1_update
    logger.info(f"Total fetch time: {total_fetch_time:.2f} seconds")
    logger.info(f"Total eval time: {total_eval_time:.2f} seconds")
    logger.info(f"Total time: {dt_update:.2f} seconds")


def update_command(args: Namespace) -> None:
    do_profile = False
    #do_profile = True

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
