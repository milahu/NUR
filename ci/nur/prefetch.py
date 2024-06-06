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
from datetime import datetime, timezone
import requests
import shlex

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
        if self.repo.new_version:
            # read cache from update_version_github_repos, update_version_git_repos, ...
            return self.repo.new_version.rev
        repo = self.repo
        t1 = time.time()
        # TODO shortcut + parallel fetch with aiohttp
        # a: https://gitlab.com/repos-holder/nur-packages
        # b: https://gitlab.com/repos-holder/nur-packages.git/info/refs?service=git-upload-pack
        cmd = ["git", "ls-remote", self.repo.url.geturl(), self.repo.branch or "HEAD"]
        logger.debug(f"repo {self.repo.name}: running: {shlex.join(cmd)}")
        proc = subprocess.Popen(
            cmd,
            # trace http traffic of git: GIT_CURL_VERBOSE=1 GIT_TRACE=1 git
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
            t2 = time.time()
            dt = t2 - t1
            repo.fetch_time += dt
            #logger.info(f"Repository {repo.name}: prefetcher.latest_commit done after {dt}")
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
        t2 = time.time()
        dt = t2 - t1
        repo.fetch_time += dt
        #logger.info(f"Repository {repo.name}: prefetcher.latest_commit done after {dt}")
        return commit

    def latest_commit_date(self) -> Optional[str]:
        if self.repo.new_version:
            # use version from update_version_github_repos
            # do this here to also support github repos with submodules
            #logger.debug(f"GitPrefetcher.latest_commit_date: repo {self.repo.name} -> {self.repo.new_version.date}")
            return self.repo.new_version.date
        #logger.debug(f"GitPrefetcher.latest_commit_date: repo {self.repo.name} -> None")
        return None

    def prefetch(self, ref: str) -> Tuple[str, Path]:
        cmd = ["nix-prefetch-git"]
        # no. when fetching by rev, "fetch zip" is better than "git clone"
        # also, with leave-dotGit, we get a different sha256
        # -> fetch the author date separately via graphQL
        """
        # get author date of last commit
        # git -c 'safe.directory=*' -C /nix/store/1r9vwfwybvgzw4k39q3fwwrcvws212x3-nur-packages log -n1 --format=%ad
        cmd += ["--leave-dotGit"]
        """
        if self.repo.submodules:
            cmd += ["--fetch-submodules"]
        if self.repo.branch:
            cmd += ["--rev", f"refs/heads/{self.repo.branch}"]
        cmd += [self.repo.url.geturl()]
        logger.debug(f"running: {shlex.join(cmd)}")
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

        """
        logger.debug(f"stdout: {stdout.decode('utf8')}")
        logger.debug(f"stderr: {stderr.decode('utf8')}")
        """

        metadata = json.loads(stdout)

        # obsolete. path is in metadata
        """
        lines = stderr.decode("utf-8").split("\n")
        repo_path = re.search("path is (.+)", lines[-5])
        assert repo_path is not None
        path = Path(repo_path.group(1))
        """

        path = Path(metadata["path"])
        sha256 = metadata["sha256"]

        # TODO check if f"{path}/.git" exists
        """
        # git -c 'safe.directory=*' -C /path/to/repo log -n1 --format=%aI
        # https://stackoverflow.com/questions/72978485 # git safe.directory
        args = ["git", "-c", "safe.directory=*", "-C", path, "log", "-n1", "--format=%aI"]
        date = subprocess.run(args).stdout.strip()
        logger.debug(f"date: {date}")
        """

        return sha256, path
        #return sha256, path, date



class GithubPrefetcher(GitPrefetcher):
    def prefetch(self, ref: str) -> Tuple[str, Path]:
        if self.repo.submodules:
            return super().prefetch(self, ref)
        return nix_prefetch_zip(f"{self.repo.url.geturl()}/archive/{ref}.tar.gz")



class GitlabPrefetcher(GitPrefetcher):
    def prefetch(self, ref: str) -> Tuple[str, Path]:
        if self.repo.submodules:
            return super().prefetch(self, ref)
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
            #logger.debug(f"persist_to_file: cache keys: {cache.keys()}")
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
        def new_func(param, **kwargs):
            key = get_key(param)
            time_expired = time.time() - expire
            force = kwargs.get("force", False)
            if not force and key in cache and cache[key].get("time") < time_expired:
                # expire cache entry
                logger.debug(f"persist_to_file: cache expired for key: {key}")
                del cache[key]
            if force or key not in cache:
                # write cache
                #logger.debug(f"persist_to_file: cache miss for key: {key}")
                value = None
                error = None
                try:
                    value = original_func(param, **kwargs)
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
def prefetch(repo: Repo, force=False) -> Tuple[Repo, LockedVersion, Optional[Path]]:
    prefetcher: GitPrefetcher
    if repo.type == RepoType.GITHUB:
        prefetcher = GithubPrefetcher(repo)
    elif repo.type == RepoType.GITLAB:
        prefetcher = GitlabPrefetcher(repo)
    else:
        prefetcher = GitPrefetcher(repo)

    # TODO when do we set repo.new_version
    # repo.new_version = ...
    commit = prefetcher.latest_commit()
    date = prefetcher.latest_commit_date()
    #date = repo.new_version.date

    # FIXME also check equality for repo.submodules

    locked_version = repo.locked_version
    if not force and locked_version is not None:
        if locked_version.rev == commit:
            #logger.debug(f"Repository {repo.name}: Up to date at {commit}")
            return repo, locked_version, None

    # TODO refactor with repo.locked_version
    locked_version = repo.eval_error_version
    if not force and locked_version is not None:
        if locked_version.rev == commit:
            #logger.debug(f"Repository {repo.name}: Up to date at {commit} (previous eval error)")
            return repo, locked_version, None

    """
    logger.debug(f"Repository {repo.name}: repo.eval_error_version = {repo.eval_error_version}")
    logger.debug(f"Repository {repo.name}: repo.locked_version     = {repo.locked_version}")
    logger.debug(f"Repository {repo.name}: commit                  = {commit}")
    logger.debug(f"Repository {repo.name}: force                   = {force}")
    """

    #logger.info(f"Repository {repo.name}: Version changed from {locked_version and locked_version.rev} to {commit}. Fetching ...")
    logger.info(f"Repository {repo.name}: Fetching new version {commit}")

    t1 = time.time()

    sha256, path = prefetcher.prefetch(commit)

    t2 = time.time()
    dt = t2 - t1
    repo.fetch_time += dt
    #logger.info(f"Repository {repo.name}: prefetcher.prefetch done after {dt}")

    return repo, LockedVersion(repo.url, commit, sha256, repo.submodules, date), path



import asyncio
import aiohttp
import io



async def update_version_git_repos(repos, aiohttp_session, filter_repos_fn):

    git_repos = list(filter(filter_repos_fn, repos))

    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")
    if debug_nur_repo:
        def filter_fn(repo):
            return repo.name == debug_nur_repo
        git_repos = list(filter(filter_fn, git_repos))

    if len(git_repos) == 0:
        return

    logger.debug(f"Updating versions of {len(git_repos)} git repos")
    #logger.debug(f"Updating versions of {len(git_repos)} git repos: {list(map(lambda r: r.name, git_repos))}")

    # TODO shortcut + parallel fetch with aiohttp
    # a: https://gitlab.com/repos-holder/nur-packages
    # b: https://gitlab.com/repos-holder/nur-packages.git/info/refs?service=git-upload-pack

    # parse smart server reply
    # https://git-scm.com/docs/gitprotocol-http#_smart_clients
    # https://willschenk.com/howto/2021/interacting_with_git_via_http/
    # https://github.com/jelmer/dulwich/blob/ee0223452ddad06224fbfbda668d9f8fce23ee24/dulwich/client.py#L501
    def read_git_upload_pack(_bytes):
        bio = io.BytesIO(_bytes)
        seen_capabitilities = False
        while True:
            head = bio.read(4)
            if head == b"":
                return
            size = int(head, 16)
            if size == 0:
                continue # ignore empty lines
            line = bio.read(size - 4)
            # assume: server sends capabitilities only once
            if not seen_capabitilities:
                parts = line.split(b"\0")
                if len(parts) > 1:
                    seen_capabitilities = True
                    line = parts[0] # ignore capabitilities
            yield line.rstrip()

    async def repo_set_new_version(repo):
        url = repo.url.geturl()
        if url.endswith("/"):
            url = url[:-1]
        # sr.ht fails with ".git" urls
        # gitlab redirects to ".git" urls
        if url.endswith(".git"):
            url = url[:-4]
        url += "/info/refs?service=git-upload-pack"

        try:
            async with aiohttp_session.get(url) as response:
                if response.status != 200:
                    logger.debug(f"repo {repo.name}: failed to fetch new version from {url}: http status {response.status}")
                    return
                _bytes = await response.read()
        except Exception as exc:
            logger.debug(f"repo {repo.name}: failed to fetch new version from {url}: {exc}")
            return

        commit = None

        for line in read_git_upload_pack(_bytes):

            #logger.debug(f"repo {repo.name}: git_upload_pack line {line}")

            if line == None:
                continue

            if line[0] == b"#"[0]:
                continue

            rev, ref = line.decode("ascii").split(" ")

            if not repo.branch:
                # use the first rev. ref == "HEAD"
                commit = rev
                break

            if ref == f"refs/heads/{repo.branch}":
                commit = rev
                break

        if commit == None:
            logger.debug(f"repo {repo.name}: not found latest rev")
            return

        #logger.debug(f"repo {repo.name}: found latest rev {commit}")

        commit_date = None

        repo.new_version = LockedVersion(repo.url.geturl(), commit, None, repo.submodules, commit_date)

    #if len(git_repos) > 0: git_repos = [ git_repos[0] ] # debug

    await asyncio.gather(*map(asyncio.create_task, map(repo_set_new_version, git_repos)))



async def update_version_github_repos(repos, aiohttp_session, filter_repos_fn):
    # timing: 8 seconds for 224 repos = 0.035 sec/repo. 30x faster than 1.0 sec/repo
    # note: this must be a "classic" token for general use
    # https://github.com/settings/tokens

    # update without graphql: 15 minutes
    # update with graphql: 15 seconds -> 60x faster

    # FIXME repos should be dict, not list

    # TODO cache, similar to persist_to_file

    github_repos = list(filter(filter_repos_fn, repos))

    debug_nur_repo = os.getenv("DEBUG_NUR_REPO")
    if debug_nur_repo:
        def filter_fn(repo):
            return repo.name == debug_nur_repo
        github_repos = list(filter(filter_fn, github_repos))

    if len(github_repos) == 0:
        return

    GITHUB_GRAPHQL_CACHE_PATH = "github-graphql-cache.json"

    github_graphql_cache_max_age = 10*60 # 10 minutes

    def file_age(filepath):
        return time.time() - os.path.getmtime(filepath)

    def is_valid_cache(path, max_age):
        if not os.path.exists(path):
            return False
        return (file_age(path) <= max_age)

    def get_repo_id(s):
        return int(s[1:]) # "r123" -> 123

    """
    if is_valid_cache(GITHUB_GRAPHQL_CACHE_PATH, 10*60):
        # read cache
        logger.debug(f"reading repo.new_version from cache {GITHUB_GRAPHQL_CACHE_PATH}")
        with open(GITHUB_GRAPHQL_CACHE_PATH) as f:
            data = json.load(f)

    else:
    """
    if True:
        github_api_token = os.getenv("GRAPHQL_TOKEN_GITHUB")
        if not github_api_token:
            github_api_token = os.getenv("API_TOKEN_GITHUB")
        if not github_api_token:
            logger.info("missing env GRAPHQL_TOKEN_GITHUB, using slow update")
            return

        logger.info(f"Updating versions of {len(github_repos)} Github repos")

        query = "query{\n"
        done_first = False
        # TODO future: split into multiple smaller queries
        # TODO what about non-github repos? use graphQL API of codeberg.org etc?
        for repo_id, repo in enumerate(github_repos):
            if done_first:
                query += ",\n"
            else:
                done_first = True
            # test query:
            # {r0:repository(owner:"milahu",name:"nur-packages"){defaultBranchRef{target{... on Commit{oid,authoredDate}}}}}
            # https://docs.github.com/en/graphql/overview/explorer
            owner, name = repo.url.geturl().split("/")[3:5]
            query += f'r{repo_id}:'
            query += f'repository(owner:"{owner}",name:"{name}")'
            # adding authoredDate has no effect on performance
            # the query takes about 6 to 8 seconds for 300 repos
            #query += "{defaultBranchRef{target{... on Commit{oid}}}}"
            query += "{defaultBranchRef{target{... on Commit{oid,authoredDate}}}}"
        query += "\n}"
        t1 = time.time()
        response = requests.post(
            url="https://api.github.com/graphql",
            json={"query": query}, # TODO send as plain text?
            headers={"Authorization": f"token {github_api_token}"}
        )
        if "X-RateLimit-Used" in response.headers:
            logger.debug("Github ratelimit status: Used %s of %s requests. Next reset in %s minutes" % (
                response.headers["X-RateLimit-Used"],
                response.headers["X-RateLimit-Limit"],
                datetime.fromtimestamp(int(response.headers["X-RateLimit-Reset"]) - time.time(), tz=timezone.utc).strftime("%M:%S")
            ))
        t2 = time.time()
        dt = t2 - t1
        logger.debug(f"Github GraphQL query done in {dt:.2} seconds")
        data = response.json()
        if response.status_code != 200:
            logger.error(f'Github GraphQL query failed with HTTP status {response.status_code}: {data} -> falling back to update_version_git_repos')
            await update_version_git_repos(repos, aiohttp_session, filter_repos_fn)
            return

        new_dict = dict()
        for item_key, item in data["data"].items():
            if not item:
                # error. already handled in the previous loop
                continue
            repo_id = get_repo_id(item_key)
            repo = github_repos[repo_id]
            new_dict[repo.name] = item
        data["data"] = new_dict

        """
        # write cache
        logger.debug(f"writing cache {GITHUB_GRAPHQL_CACHE_PATH}")
        with open(GITHUB_GRAPHQL_CACHE_PATH, "w") as f:
            json.dump(data, f)
        """

    #print("data:"); print(data)

    for error in data.get("errors", []):
        if len(error["path"]) != 1:
            logger.error(f'unexpected path length {len(error["path"])} in path {error["path"]}')
            continue
        repo_id = get_repo_id(error["path"][0])
        repo = github_repos[repo_id]
        repo.error = RepoNotFoundError("Github GraphQL error: " + error["message"])

    #for item_key, item in data["data"].items():
    for repo_name, item in data["data"].items():
        if not item:
            # error. already handled in the previous loop
            continue
        #repo_id = get_repo_id(item_key)
        #repo = github_repos[repo_id]

        # FIXME repos should be dict, not list
        #repo = repos[repo_name]
        repo = next((r for r in repos if r.name == repo_name), None)
        if repo == None:
            continue

        commit = item["defaultBranchRef"]["target"]["oid"]
        #repo.new_version = LockedVersion(repo.url.geturl(), commit, None, repo.submodules)
        commit_date = item["defaultBranchRef"]["target"].get("authoredDate")
        # example: 2024-04-11T12:18:16Z
        #logger.debug(f"repo {repo.name}: commit_date = {commit_date} -> setting repo.new_version")
        repo.new_version = LockedVersion(repo.url.geturl(), commit, None, repo.submodules, commit_date)
        #logger.debug(f"repo {repo.name}: repo.new_version.date = {repo.new_version.date}")
        if repo.new_version == repo.locked_version:
            logger.info(f"Repository {repo.name}: Done. No change in version {repo.locked_version.rev}")
            repo.done = True
