#!/usr/bin/env bash

set -x

data_branches="nur-repos nur-repos-lock nur-eval-results nur-eval-errors gh-pages"

for branch in $data_branches; do
  if [ -d $branch ]; then
    git worktree remove $branch
  fi
  git fetch --force origin $branch:$branch
  git worktree add $branch $branch
done
