#!/usr/bin/env python3

import json
import os
import sys
import shutil
from pathlib import Path
from typing import Any, DefaultDict, Dict, List
import requests
import logging

ROOT = Path(__file__).parent.parent.resolve()

repo_owner = os.getenv("GITHUB_REPOSITORY_OWNER") or "nix-community"
nur_repo_name = os.getenv("NUR_REPO_NAME") or "NUR"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Package:
    def __init__(self, attribute: str, metadata: Dict[str, Any]) -> None:
        self.attribute = attribute
        self.metadata = metadata


def write_repo_page(repos_path: Path, repo_name: str, pkgs: List[Package]):
    with open(str(repos_path.joinpath(repo_name)) + ".md", "w+") as f:
        f.write(
            f"""
+++
title = "{repo_name}"
+++

# Packages

<style>
table td {{
overflow-wrap: break-word;
}}
</style>

Name | Attribute | Description
-----|-----------|------------
"""
        )
        for pkg in pkgs:
            name = pkg.metadata["name"]
            meta = pkg.metadata["meta"]
            description = meta.get("description")
            if description is None:
                description = ""

            description = description.replace("\n", "")
            homepage = meta.get("homepage", None)
            attribute = pkg.attribute

            if homepage is not None:
                name = f"[{name}]({homepage})"

            location = meta.get("position", None)
            if location is not None:
                attribute = f"[{attribute}]({location})"

            f.write(f"{name}|{attribute}|{description}\n")

def download_readme():
    url = f"https://raw.githubusercontent.com/{repo_owner}/{nur_repo_name}/master/README.md"
    r = requests.get(url)
    with open("content/documentation/_index.md", 'wb') as f:
        fm = bytes("""
+++
title = "Documentation"
weight = 1
alwaysopen = true
+++
""", 'utf-8')
        f.write(fm)
        f.write(r.content)

def create_repos_section():
    repos_path = ROOT.joinpath("content", "repos")
    shutil.rmtree(repos_path, ignore_errors=True)
    os.makedirs(repos_path)
    with open(repos_path.joinpath("_index.md"), "w+") as f:
        f.write("""
+++
title = "Repos"
weight = 10
alwaysopen = true
+++
# Repo index

""")

def main() -> None:

    logger.info("generating pages ...")

    download_readme()

    with open(ROOT.joinpath("data", "packages.json")) as f:
        if f.read(1) == '':
            # packages.json is empty
            # json.load(f) would fail with json.decoder.JSONDecodeError
            logger.error("packages.json is empty")
            sys.exit(1)
        f.seek(0)
        repos: DefaultDict[str, List[Package]] = DefaultDict(list)
        packages = json.load(f)
        pkg_count = 0
        for attribute, pkg in packages.items():
            pkg_count += 1
            repos[pkg["_repo"]].append(Package(attribute, pkg))

        repos_path = ROOT.joinpath("content", "repos")
        create_repos_section()

        repo_count = 0
        for repo_name, pkgs in repos.items():
            repo_count += 1
            write_repo_page(repos_path, repo_name, pkgs)

        stats_dict={'repo_count':repo_count, 'pkg_count': pkg_count}
        stats_path = ROOT.joinpath("data", "stats.json")
        with open(stats_path, "w+") as f:
            f.write(json.dumps(stats_dict))

    logger.info("generating pages done")


if __name__ == "__main__":
    main()
