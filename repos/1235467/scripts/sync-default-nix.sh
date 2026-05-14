#!/usr/bin/env bash
# sync-default-nix.sh — Regenerate default.nix from flake.nix
#
# Usage:
#   ./scripts/sync-default-nix.sh          check mode: show diff (default)
#   ./scripts/sync-default-nix.sh --write  write mode: update default.nix
#
# The script extracts package definitions from flake.nix and rebuilds
# default.nix with the correct header/parameters and preserved footer.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"
FLAKE="$REPO/flake.nix"
DEFAULT="$REPO/default.nix"
AWK_SCRIPT="$SCRIPT_DIR/sync-extract.awk"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MODE="${1:---check}"

# ---------------------------------------------------------------------------
# Extract the transformed package body from flake.nix
# ---------------------------------------------------------------------------
extract_packages() {
  awk -f "$AWK_SCRIPT" "$FLAKE"
}

# ---------------------------------------------------------------------------
# Extract dream2nix commented block from existing default.nix
# ---------------------------------------------------------------------------
extract_dream2nix() {
  awk '
    /^  # dream2nix$/        { found = 1 }
    found && /^  # Broken$/  { exit }
    found                    { print }
  ' "$DEFAULT"
}

# ---------------------------------------------------------------------------
# Extract broken section from existing default.nix
# ---------------------------------------------------------------------------
extract_broken() {
  awk '
    /^  # Broken$/ { found = 1 }
    found          { print }
  ' "$DEFAULT"
}

# ---------------------------------------------------------------------------
# Generate new default.nix
# ---------------------------------------------------------------------------
generate() {
  cat <<'HEADER'
# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { }
, pkgs-stable ? import <nixpkgs> { }
, pkgs-yuzu ? import <nixpkgs> { }
, pkgs-chaotic ? null
,
}:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # Eval Helper
  sources = pkgs.callPackage ./_sources/generated.nix { };

HEADER

  extract_packages

  echo

  extract_dream2nix

  extract_broken
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

case "$MODE" in
  --check)
    TMP="$(mktemp)"
    trap "rm -f $TMP" EXIT
    generate > "$TMP"

    if diff -u "$DEFAULT" "$TMP"; then
      echo -e "${GREEN}default.nix is in sync with flake.nix${NC}"
    else
      echo -e "${YELLOW}^^^ Differences found. Run with --write to update.${NC}"
      exit 1
    fi
    ;;

  --write)
    TMP="$(mktemp)"
    generate > "$TMP"

    if diff -u "$DEFAULT" "$TMP" >/dev/null 2>&1; then
      echo -e "${GREEN}default.nix is already in sync${NC}"
      rm -f "$TMP"
    else
      cp "$TMP" "$DEFAULT"
      rm -f "$TMP"
      echo -e "${GREEN}default.nix updated from flake.nix${NC}"
    fi
    ;;

  *)
    echo "Usage: $0 [--check|--write]"
    exit 1
    ;;
esac
