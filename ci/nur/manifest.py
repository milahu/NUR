import os
import json
from enum import Enum, auto
from pathlib import Path
from typing import Dict, List, Optional, Any
from urllib.parse import ParseResult, urlparse
import logging

from .fileutils import PathType, to_path, write_json_file
from .error import EvalError
from .path import ROOT_PATH

Url = ParseResult

logger = logging.getLogger(__name__)


class LockedVersion:
    def __init__(
        self, url: Url, rev: str, sha256: str, submodules: bool = False
    ) -> None:
        self.url = url
        self.rev = rev
        self.sha256 = sha256
        self.submodules = submodules

    def __eq__(self, other: Any) -> bool:
        if type(other) is type(self):
            return self.__dict__ == other.__dict__
        return False

    def as_json(self) -> Dict[str, Any]:
        d = dict(
            url=self.url.geturl(), rev=self.rev, sha256=self.sha256
        )  # type: Dict[str, Any]
        if self.submodules:
            d["submodules"] = self.submodules
        return d

    def __repr__(self) -> str:
        # git is content-addressed, so rev is a global identifier
        return self.rev


class RepoType(Enum):
    GITHUB = auto()
    GITLAB = auto()
    GIT = auto()

    @staticmethod
    def from_repo(repo: "Repo", type_: Optional[str]) -> "RepoType":
        if repo.submodules:
            return RepoType.GIT
        if repo.url.hostname == "github.com":
            return RepoType.GITHUB
        if repo.url.hostname == "gitlab.com" or type_ == "gitlab":
            return RepoType.GITLAB
        else:
            return RepoType.GIT


class Repo:
    def __init__(
        self,
        name: str,
        url: Url,
        submodules: bool,
        supplied_type: Optional[str],
        file_: Optional[str],
        branch: Optional[str],
        locked_version: Optional[LockedVersion],
        eval_error_version: Optional[LockedVersion],
        eval_error_text: Optional[str],
    ) -> None:
        self.name = name
        self.url = url
        self.submodules = submodules
        if file_ is None:
            self.file = "default.nix"
        else:
            self.file = file_
        self.branch = branch
        self.locked_version = None
        self.new_version = None
        self.eval_error_version = None
        self.eval_error_text = None
        self.fetch_time = 0
        self.eval_time = 0
        self.error = None
        self.done = False

        if (
            locked_version is not None
            and locked_version.url != url.geturl()
            and locked_version.submodules == submodules
        ):
            self.locked_version = locked_version

        if eval_error_version and eval_error_text:
            self.eval_error_version = eval_error_version
            self.eval_error_text = eval_error_text

        self.supplied_type = supplied_type
        self.computed_type = RepoType.from_repo(self, supplied_type)

    @property
    def type(self) -> RepoType:
        return self.computed_type

    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} {self.name}>"

    def as_json(self) -> Dict[str, Any]:
        d = dict(url=self.url.geturl())  # type: Dict[str, Any]

        if self.submodules:
            d["submodules"] = self.submodules

        if self.supplied_type is not None:
            d["type"] = self.supplied_type

        if self.file is not None and self.file != "default.nix":
            d["file"] = self.file

        return d


class Manifest:
    def __init__(self, repos: List[Repo]) -> None:
        self.repos = repos

    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} {repr(self.repos)}>"


def _load_locked_versions(path: PathType) -> Dict[str, LockedVersion]:
    with open(path) as f:
        data = json.load(f)

    locked_versions = {}

    for name, repo in data["repos"].items():
        url = urlparse(repo["url"])
        rev = repo["rev"]
        sha256 = repo["sha256"]
        submodules = repo.get("submodules", False)
        locked_versions[name] = LockedVersion(url, rev, sha256, submodules)

    return locked_versions


def load_locked_versions(path: Path) -> Dict[str, LockedVersion]:
    if path.exists():
        return _load_locked_versions(path)
    else:
        return {}


def load_text_file(path: PathType) -> Optional[str]:
    if path.exists():
        #print(f"manifest load_text_file: loading file: {path}")
        with open(path, encoding="utf8") as f:
            return f.read()
    #else: print(f"manifest load_text_file: no such file: {path}")
    return None


def load_eval_error_text(eval_errors_path: str, name: str):
    return load_text_file(to_path(eval_errors_path).joinpath(f"{name}.txt"))


def update_lock_file(repos: List[Repo], path: Path) -> None:
    locked_repos = {}
    for repo in repos:
        if repo.locked_version:
            locked_repos[repo.name] = repo.locked_version.as_json()

    write_json_file(dict(repos=locked_repos), path)


# TODO refactor with update_lock_file
def update_eval_errors_lock_file(repos: List[Repo], path: Path) -> None:
    locked_repos = {}
    for repo in repos:
        if repo.eval_error_version:
            locked_repos[repo.name] = repo.eval_error_version.as_json()

    write_json_file(dict(repos=locked_repos), path)


def update_eval_errors(repos: List[Repo], path: Path) -> None:
    for repo in repos:
        eval_error_path = path.joinpath(f"{repo.name}.txt")
        eval_error_relpath = os.path.relpath(eval_error_path, ROOT_PATH)

        if repo.eval_error_text:
            write_error = True
            if eval_error_path.exists():
                with open(eval_error_path, "r") as f:
                    old_eval_error_text = f.read()
                if old_eval_error_text == repo.eval_error_text:
                    write_error = False
                old_eval_error_text = None
            if write_error:
                logger.debug(f"Writing error message: {eval_error_relpath}")
                with open(eval_error_path, "w") as f:
                    f.write(repo.eval_error_text)
        else:
            if eval_error_path.exists():
                logger.info(f"Deleting old error message: {eval_error_relpath}")
                os.unlink(eval_error_path)
                # TODO git clean


def load_manifest(manifest_path: PathType, lock_path: PathType, eval_errors_lock_path: PathType, eval_errors_path: PathType) -> Manifest:
    locked_versions = load_locked_versions(to_path(lock_path))
    eval_error_versions = load_locked_versions(to_path(eval_errors_lock_path))

    with open(manifest_path) as f:
        data = json.load(f)

    repos = []
    for name, repo in data["repos"].items():
        url = urlparse(repo["url"])
        submodules = repo.get("submodules", False)
        branch_ = repo.get("branch")
        file_ = repo.get("file", "default.nix")
        type_ = repo.get("type", None)
        locked_version = locked_versions.get(name)
        eval_error_version = eval_error_versions.get(name)
        eval_error_text = load_eval_error_text(eval_errors_path, name)
        repos.append(Repo(name, url, submodules, type_, file_, branch_, locked_version, eval_error_version, eval_error_text))

    return Manifest(repos)
