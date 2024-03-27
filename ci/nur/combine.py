import logging
import os
import shutil
import subprocess
from argparse import Namespace
from distutils.dir_util import copy_tree
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import Dict, List, Optional

from .fileutils import chdir, write_json_file
from .manifest import Repo, load_manifest, update_lock_file
from .path import LOCK_PATH, MANIFEST_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH, ROOT_PATH, DEFAULT_NIX_PATH, MANIFEST_LIB_PATH
from .process import prctl_set_pdeathsig

logger = logging.getLogger(__name__)


def load_combined_repos(path: Path) -> Dict[str, Repo]:
    combined_manifest = load_manifest(
        # TODO use paths from path.py with a different ROOT path
        path.joinpath("repos.json"),
        path.joinpath("repos.json.lock"),
        # no. these files are not in nur-combined/
        #path.joinpath("nur-eval-errors/repos.json.lock"),
        #path.joinpath("nur-eval-errors"),
        EVAL_ERRORS_LOCK_PATH,
        EVAL_ERRORS_PATH,
    )
    repos = {}
    for repo in combined_manifest.repos:
        repos[repo.name] = repo
    return repos


def capture_check_call(args: List[str]):
    proc = subprocess.Popen(
        args,
        preexec_fn=lambda: prctl_set_pdeathsig(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf8",
    )
    try:
        stdout, stderr = proc.communicate(timeout=30)
    except subprocess.TimeoutExpired:
        proc.kill()
        raise
    if proc.returncode != 0:
        raise Exception(f"command {args[0]} returned exit code {proc.returncode}. stderr:\n{stderr}")
    return proc, stdout, stderr


def repo_source(name: str) -> str:
    cmd = ["nix-build", str(ROOT_PATH), "--no-out-link", "-A", f"repo-sources.{name}"]
    proc, stdout, stderr = capture_check_call(cmd)
    return stdout.strip()


def repo_changed() -> bool:
    proc, stdout, stderr = capture_check_call(["git", "status", "--porcelain"])
    return stdout.strip() != ""


def commit_files(files: List[str], message: str) -> None:
    capture_check_call(["git", "add"] + files)

    if repo_changed():
        capture_check_call(["git", "commit", "-m", message])


def commit_repo(repo: Repo, message: str, path: Path) -> Repo:
    repo_path = path.joinpath(repo.name).resolve()

    tmp: Optional[TemporaryDirectory] = TemporaryDirectory(prefix=str(repo_path.parent))
    assert tmp is not None

    try:
        copy_tree(repo_source(repo.name), tmp.name, preserve_symlinks=1)
        shutil.rmtree(repo_path, ignore_errors=True)
        os.rename(tmp.name, repo_path)
        tmp = None
    finally:
        if tmp is not None:
            tmp.cleanup()

    with chdir(str(path)):
        commit_files([str(repo_path)], message)

    return repo


def update_combined_repo(
    combined_repo: Optional[Repo], repo: Repo, path: Path
) -> Optional[Repo]:
    if repo.locked_version is None:
        return None

    new_rev = repo.locked_version.rev
    if combined_repo is None:
        message = f"{repo.name}: init at {new_rev}"
        repo = commit_repo(repo, message, path)
        return repo

    assert combined_repo.locked_version is not None
    old_rev = combined_repo.locked_version.rev

    if combined_repo.locked_version == repo.locked_version:
        return repo

    if new_rev != old_rev:
        message = f"{repo.name}: {old_rev[:10]} -> {new_rev[:10]}"
    else:
        message = f"{repo.name}: update"

    repo = commit_repo(repo, message, path)
    return repo


def remove_repo(repo: Repo, path: Path) -> None:
    repo_path = path.joinpath("repos", repo.name).resolve()
    if repo_path.exists():
        shutil.rmtree(repo_path)
    with chdir(path):
        commit_files([str(repo_path)], f"{repo.name}: remove")


def update_manifest(repos: List[Repo], path: Path) -> None:
    d = {}

    for repo in repos:
        d[repo.name] = repo.as_json()
    write_json_file(dict(repos=d), path)


def update_combined(path: Path) -> None:
    manifest = load_manifest(MANIFEST_PATH, LOCK_PATH, EVAL_ERRORS_LOCK_PATH, EVAL_ERRORS_PATH)

    combined_repos = load_combined_repos(path)

    repos_path = path.joinpath("repos")
    os.makedirs(repos_path, exist_ok=True)

    updated_repos = []

    for repo in manifest.repos:
        combined_repo = None
        if repo.name in combined_repos:
            combined_repo = combined_repos[repo.name]
            del combined_repos[repo.name]
        try:
            logger.info(f"update_combined_repo {repo.name}")
            new_repo = update_combined_repo(combined_repo, repo, repos_path)
        except Exception:
            logger.exception(f"Failed to updated repository {repo.name}")
            continue

        if new_repo is not None:
            updated_repos.append(new_repo)

    for combined_repo in combined_repos.values():
        remove_repo(combined_repo, path)

    update_manifest(updated_repos, path.joinpath("repos.json"))

    update_lock_file(updated_repos, path.joinpath("repos.json.lock"))

    with chdir(path):
        commit_files(["repos.json", "repos.json.lock"], "update repos.json + lock")


def setup_combined() -> None:
    manifest_path = "repos.json"

    if not Path(".git").exists():
        cmd = ["git", "init", "."]
        capture_check_call(cmd)

    if not os.path.exists(manifest_path):
        write_json_file(dict(repos={}), manifest_path)

    manifest_lib = "lib"
    copy_tree(str(MANIFEST_LIB_PATH), manifest_lib, preserve_symlinks=1)

    default_nix = "default.nix"
    shutil.copy(DEFAULT_NIX_PATH, default_nix)

    vcs_files = [manifest_path, manifest_lib, default_nix]

    commit_files(vcs_files, "update code")


def combine_command(args: Namespace) -> None:
    logger.info(f"combine_command")
    combined_path = Path(args.directory)

    with chdir(combined_path):
        logger.info(f"setup_combined")
        setup_combined()
    logger.info(f"update_combined")
    update_combined(combined_path)
