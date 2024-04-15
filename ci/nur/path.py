import os
import subprocess
from pathlib import Path

from .error import NurError


def _is_repo(path: Path) -> bool:
    return path.joinpath("lib/evalRepo.nix").exists()


def _find_root() -> Path:
    source_root = Path(__file__).parent.parent.resolve()
    if _is_repo(source_root):
        # if it was not build with release.nix
        return source_root
    else:
        root = Path(os.getcwd()).resolve()

        while True:
            if _is_repo(root):
                return root
            new_root = root.parent.resolve()
            if new_root == root:
                if _is_repo(new_root):
                    return new_root
                else:
                    raise NurError("NUR repository not found in current directory")
            root = new_root


# note: we need to resolve absolute paths so later we can chdir
ROOT_PATH = Path(os.environ.get("ROOT_PATH", _find_root())).resolve()
DEFAULT_NIX_PATH = Path(os.environ.get("DEFAULT_NIX_PATH", ROOT_PATH.joinpath("default.nix"))).resolve()
MANIFEST_LIB_PATH = Path(os.environ.get("MANIFEST_LIB_PATH", ROOT_PATH.joinpath("lib"))).resolve()
LOCK_PATH = Path(os.environ.get("LOCK_PATH", ROOT_PATH.joinpath("repos.json.lock"))).resolve()
MANIFEST_PATH = Path(os.environ.get("MANIFEST_PATH", ROOT_PATH.joinpath("repos.json"))).resolve()
EVALREPO_PATH = Path(os.environ.get("EVALREPO_PATH", ROOT_PATH.joinpath("lib/evalRepo.nix"))).resolve()
EVAL_RESULTS_PATH = Path(os.environ.get("EVAL_RESULTS_PATH", ROOT_PATH.joinpath("nur-eval-results"))).resolve()
EVAL_ERRORS_PATH = Path(os.environ.get("EVAL_ERRORS_PATH", ROOT_PATH.joinpath("nur-eval-errors"))).resolve()
EVAL_ERRORS_LOCK_PATH = Path(os.environ.get("EVAL_ERRORS_LOCK_PATH", ROOT_PATH.joinpath("nur-eval-errors/repos.json.lock"))).resolve()
# TODO use prefetch-cache.json -> make "class Repo" json-serializable
PREFETCH_CACHE_PATH = Path(os.environ.get("PREFETCH_CACHE_PATH", ROOT_PATH.joinpath("prefetch-cache.pickle"))).resolve()
COMBINED_REPOS_PATH = Path(os.environ.get("COMBINED_REPOS_PATH", ROOT_PATH.joinpath("nur-combined"))).resolve()

_NIXPKGS_PATH = os.environ.get("NIXPKGS_PATH", None)

def get_nixpkgs_path() -> str:
    global _NIXPKGS_PATH
    if _NIXPKGS_PATH is not None:
        return _NIXPKGS_PATH

    if "NIX_PATH" in os.environ:
        for item in os.environ["NIX_PATH"].split(":"):
            if item.startswith("nixpkgs=/"):
                path = item[8:]
                _NIXPKGS_PATH = str(Path(path).resolve())
                return _NIXPKGS_PATH

    cmd = ["nix-instantiate", "--find-file", "nixpkgs"]
    path = subprocess.check_output(cmd).decode("utf-8").strip()
    _NIXPKGS_PATH = str(Path(path).resolve())

    return _NIXPKGS_PATH

nixpkgs_path = get_nixpkgs_path()
