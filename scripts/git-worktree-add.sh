#! /usr/bin/env bash

set -x

for branch in gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search nur-search-data; do
  git worktree add $branch $branch

  # fetch submodules
  # nur-search has a git module for hugo theme
  git -C $branch submodule update --init --depth=1 --recursive
done

# unmount branch:
# git -C $branch submodule deinit --all --force
# git worktree remove $branch --force
