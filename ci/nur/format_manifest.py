import json
import shutil
import sys
from argparse import Namespace

from .path import MANIFEST_PATH


def format_manifest_command(args: Namespace) -> None:
    path = MANIFEST_PATH
    manifest = json.load(open(path))
    for name, repo in manifest.get("repos", []).items():
        if "url" not in repo:
            print(f"{name} has no url", file=sys.stderr)
            sys.exit(1)

        if "github-contact" not in repo:
            print(f"{name} has no github contact", file=sys.stderr)
            sys.exit(1)

    tmp_path = str(path) + ".tmp"
    with open(tmp_path, "w+") as tmp:
        json.dump(manifest, tmp, indent=4, sort_keys=True)
        tmp.write("\n")
    shutil.move(tmp_path, path)
