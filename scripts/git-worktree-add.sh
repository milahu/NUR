#! /usr/bin/env bash

source "$(dirname "$0")"/.common.sh

set -ux

for branch in ${git_branches[@]}; do
  git worktree add $branch $branch

  # fetch submodules
  # nur-search has a git module for hugo theme
  git -C $branch submodule update --init --depth=1 --recursive
done

# unmount branch:
# git -C $branch submodule deinit --all --force
# git worktree remove $branch --force
