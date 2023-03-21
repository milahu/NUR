import logging
import json
import os
import re
import subprocess
from pathlib import Path
from typing import Optional, Tuple
from urllib.parse import ParseResult
import time
import pickle

from .error import NurError, RepoNotFoundError
from .manifest import LockedVersion, Repo, RepoType
from .path import PREFETCH_CACHE_PATH
from .process import prctl_set_pdeathsig

Url = ParseResult

logger = logging.getLogger(__name__)


def nix_prefetch_zip(url: str) -> Tuple[str, Path]:
    data = subprocess.check_output(
        ["nix-prefetch-url", "--name", "source", "--unpack", "--print-path", url]
    )
    sha256, path = data.decode().strip().split("\n")
    return sha256, Path(path)


class GitPrefetcher:
    def __init__(self, repo: Repo) -> None:
        self.repo = repo

    def latest_commit(self) -> str:
        cmd = ["git", "ls-remote", self.repo.url.geturl(), self.repo.branch or "HEAD"]
        proc = subprocess.Popen(
            cmd,
            # setting these envs produces false errors:
            # false error: fatal: could not read Username for 'https://github.com': terminal prompts disabled
            # true error: remote: Repository not found.\nfatal: repository 'https://github.com/x/y' not found
            #env={**os.environ, "GIT_ASKPASS": "", "GIT_TERMINAL_PROMPT": "0"},
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            encoding="utf8",
            preexec_fn=lambda: prctl_set_pdeathsig(),
        )
        try:
            stdout, stderr = proc.communicate(timeout=30)
        except subprocess.TimeoutExpired:
            proc.kill()
            raise NurError(
                f"Timeout expired while prefetching git repository {self.repo.url.geturl()}"
            )
        if proc.returncode != 0:
            if proc.returncode == 128 and stderr.startswith("remote: Repository not found."):
                raise RepoNotFoundError(f"Not found git repository {self.repo.url.geturl()}")
            raise NurError(
                f"Failed to prefetch git repository {self.repo.url.geturl()}: {stderr}"
            )
        commit = stdout.split(sep="\t")[0]
        if len(commit) != 40:
            raise NurError(
                f"git ls-remote did not return a git commit hash. actual output:\n{stdout}"
            )
        return commit

    def prefetch(self, ref: str) -> Tuple[str, Path]:
        cmd = ["nix-prefetch-git"]
        if self.repo.submodules:
            cmd += ["--fetch-submodules"]
        if self.repo.branch:
            cmd += ["--rev", f"refs/heads/{self.repo.branch}"]
        cmd += [self.repo.url.geturl()]
        proc = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            preexec_fn=lambda: prctl_set_pdeathsig(),
        )
        try:
            stdout, stderr = proc.communicate(timeout=30)
        except subprocess.TimeoutExpired:
            proc.kill()
            raise NurError(
                f"Timeout expired while prefetching git repository {self. repo.url.geturl()}"
            )

        if proc.returncode != 0:
            raise NurError(
                f"Failed to prefetch git repository {self.repo.url.geturl()}: {stderr.decode('utf-8')}"
            )

        metadata = json.loads(stdout)
        lines = stderr.decode("utf-8").split("\n")
        repo_path = re.search("path is (.+)", lines[-5])
        assert repo_path is not None
        path = Path(repo_path.group(1))
        sha256 = metadata["sha256"]
        return sha256, path


class GithubPrefetcher(GitPrefetcher):
    def prefetch(self, ref: str) -> Tuple[str, Path]:
        return nix_prefetch_zip(f"{self.repo.url.geturl()}/archive/{ref}.tar.gz")


class GitlabPrefetcher(GitPrefetcher):
    def prefetch(self, ref: str) -> Tuple[str, Path]:
        hostname = self.repo.url.hostname
        assert (
            hostname is not None
        ), f"Expect a hostname for Gitlab repo: {self.repo.name}"
        path = Path(self.repo.url.path)
        escaped_path = "%2F".join(path.parts[1:])
        url = f"https://{hostname}/api/v4/projects/{escaped_path}/repository/archive.tar.gz?sha={ref}"
        return nix_prefetch_zip(url)


# default expire: 60 minutes
def persist_to_file(cache_file, get_key, expire=60*60):
    cache = {}
    try:
        logger.debug(f"persist_to_file: reading cache file {cache_file} ...")
        with open(cache_file, "rb") as f:
            cache = pickle.load(f)
            logger.debug(f"persist_to_file: cache keys: {cache.keys()}")
            time_expired = time.time() - expire
            # fix: RuntimeError: dictionary changed size during iteration
            #for key in cache:
            for key in list(cache.keys()):
                entry = cache[key]
                if entry.get("time") < time_expired:
                    del cache[key]
            logger.debug(f"persist_to_file: reading cache file {cache_file} done")
    except (IOError, ValueError) as err:
        # no such file, etc
        logger.debug(f"persist_to_file: reading cache file {cache_file} failed: {err}")
        pass
    def decorator(original_func):
        def new_func(param):
            key = get_key(param)
            time_expired = time.time() - expire
            if key in cache and cache[key].get("time") < time_expired:
                # expire cache entry
                logger.debug(f"persist_to_file: cache expired for key: {key}")
                del cache[key]
            if key not in cache:
                # write cache
                #logger.debug(f"persist_to_file: cache miss for key: {key}")
                value = None
                error = None
                try:
                    value = original_func(param)
                except Exception as e:
                    error = e
                cache[key] = {
                    "time": time.time(),
                    "value": value,
                    "error": error,
                }
                #logger.debug(f"persist_to_file: writing cache file {cache_file}")
                with open(cache_file, "wb") as f:
                    pickle.dump(cache, f)
            #else: logger.debug(f"persist_to_file: cache hit for key: {key}")
            # read cache
            error = cache[key].get("error")
            if error:
                raise error
            return cache[key].get("value")
        return new_func
    return decorator


@persist_to_file(PREFETCH_CACHE_PATH, lambda repo: repo.name)
def prefetch(repo: Repo) -> Tuple[Repo, LockedVersion, Optional[Path]]:
    prefetcher: GitPrefetcher
    if repo.type == RepoType.GITHUB:
        prefetcher = GithubPrefetcher(repo)
    elif repo.type == RepoType.GITLAB:
        prefetcher = GitlabPrefetcher(repo)
    else:
        prefetcher = GitPrefetcher(repo)

    commit = prefetcher.latest_commit()

    # FIXME also check equality for repo.submodules

    locked_version = repo.locked_version
    if locked_version is not None:
        if locked_version.rev == commit:
            return repo, locked_version, None

    # TODO refactor with repo.locked_version
    locked_version = repo.eval_error_version
    if locked_version is not None:
        if locked_version.rev == commit:
            return repo, locked_version, None

    sha256, path = prefetcher.prefetch(commit)
    return repo, LockedVersion(repo.url, commit, sha256, repo.submodules), path
