#!/usr/bin/env bash

set -eu -o pipefail # Exit with nonzero exit code if anything fails

$(nix-build --no-out-link release.nix)/bin/nur format-manifest
if [ -n "$(git diff --exit-code repos.json)" ]; then
  echo "repos.json was not formatted before committing repos.json:" >&2
  git diff --exit-code repos.json
  echo "Please run ./bin/nur/format-manifest.py and updates repos.json accordingly!" >&2
  exit 1
fi

# Type checker
nix run nixpkgs.python3Packages.mypy -c mypy nur
# Format checker
nix run nixpkgs.python3Packages.black -c black --check .
# Linter
nix run nixpkgs.python3Packages.flake8 -c flake8 .
