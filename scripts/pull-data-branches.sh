#!/usr/bin/env bash

set -x

data_branches="nur-repos-lock nur-eval-results nur-eval-errors gh-pages"

for branch in $data_branches; do
  if ! [ -d $branch ]; then
    git worktree add $branch $branch
  fi
  git -C $branch pull origin $branch
done
