#! /usr/bin/env bash

set -x

for branch in gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search; do
  git worktree add $branch $branch
done
