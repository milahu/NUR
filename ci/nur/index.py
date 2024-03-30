import json
import subprocess
import sys
import os
from argparse import Namespace
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any, Dict


repo_owner = os.getenv("GITHUB_REPOSITORY_OWNER") or "nix-community"
# TODO use COMBINED_REPO_URL like in ci/update-nur-search.sh, dont require github
combined_repo_name = os.getenv("COMBINED_REPO_NAME") or "NUR"
combined_repo_branch = os.getenv("COMBINED_REPO_BRANCH") or "nur-combined"
nur_repo_name = os.getenv("NUR_REPO_NAME") or "NUR"


def resolve_source(pkg: Dict, repo: str, url: str, combined_repo_path: Path) -> str:
    # TODO commit hash
    prefix = f"https://github.com/{repo_owner}/{combined_repo_name}/tree/{combined_repo_branch}/repos/{repo}"
    position = pkg["meta"].get("position", None)
    this_repo_path = str(combined_repo_path.joinpath("repos", repo).resolve())
    if position is not None and position.startswith("/nix/store"):
        path_str, line = position.rsplit(":", 1)
        path = Path(path_str)
        # I've decided to just take these 2 repositories,
        # update this whenever someone decided to use a recipe source other than
        # NUR or nixpkgs to override packages on. right now this is about as accurate as
        # `nix edit` is
        # TODO find commit hash
        prefixes = {
            "nixpkgs": "https://github.com/nixos/nixpkgs/tree/master/",
            "nur": f"https://github.com/{repo_owner}/{combined_repo_name}/tree/{combined_repo_branch}/",
        }
        stripped = path.parts[4:]
        if path.parts[3].endswith("source"):

            canonical_url = url
            # if we want to add the option of specifying branches, we have to update this
            if "github" in url:
                canonical_url += "/blob/HEAD/"
            elif "gitlab" in url:
                canonical_url += "/-/blob/HEAD/"
            attr_path = "/".join(stripped)
            location = f"{canonical_url}{attr_path}"
            return f"{location}#L{line}"
        elif stripped[0] not in prefixes:
            print(path, file=sys.stderr)
            print(
                f"we could not find {stripped} , you can file an issue at https://github.com/{repo_owner}/{nur_repo_name}/issues to the indexing file if you think this is a mistake",
                file=sys.stderr,
            )
            return prefix
        else:
            attr_path = "/".join(stripped[1:])
            location = f"{prefixes[stripped[0]]}{attr_path}"
            return f"{location}#L{line}"
    elif position is not None and position.startswith(this_repo_path):
        path_str, line = position.rsplit(":", 1)
        stripped = path_str[len(this_repo_path):]
        return f"{prefix}{stripped}#L{line}"
    else:
        return prefix


def index_repo(
    directory: Path, repo: str, expression_file: str, url: str
) -> Dict[str, Any]:
    combined_repo_path = directory
    default_nix = directory.joinpath("default.nix").resolve()
    expr = """
with import <nixpkgs> {};
let
  nur = import %s { nurpkgs = pkgs; inherit pkgs; };
in
callPackage (nur.repo-sources."%s" + "/%s") {}
""" % (
        default_nix,
        repo,
        expression_file,
    )

    with NamedTemporaryFile(mode="w") as f:
        f.write(expr)
        f.flush()
        env = os.environ.copy()
        env.update(NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM="1")
        query_cmd = ["nix-env", "-qa", "*", "--json", "--meta", "-f", str(f.name)]
        try:
            # TODO? encoding="utf8"
            out = subprocess.check_output(query_cmd, env=env)
        except subprocess.CalledProcessError:
            print(f"failed to evaluate {repo}", file=sys.stderr)
            return {}

        # debug: print result of nix-env
        #print(f"done evaluating {repo}: {out}", file=sys.stderr)

        raw_pkgs = json.loads(out)
        pkgs = {}
        for name, pkg in raw_pkgs.items():
            pkg["_attr"] = name
            pkg["_repo"] = repo
            pkg["meta"]["position"] = resolve_source(pkg, repo, url, combined_repo_path)
            pkgs[f"nur.repos.{repo}.{name}"] = pkg

        return pkgs


def index_command(args: Namespace) -> None:
    directory = Path(args.directory)
    manifest_path = directory.joinpath("repos.json")
    with open(manifest_path) as f:
        manifest = json.load(f)
    repos = manifest.get("repos", [])
    pkgs: Dict[str, Any] = {}

    for (repo, data) in repos.items():
        repo_pkgs = index_repo(
            directory,
            repo,
            data.get("file", "default.nix"),
            data.get("url", "https://github.com/nixos/nixpkgs"),
        )
        pkgs.update(repo_pkgs)

    json.dump(pkgs, sys.stdout, indent=4)
