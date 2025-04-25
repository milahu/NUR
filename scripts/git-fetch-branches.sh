#! /usr/bin/env bash

set -x

for branch in gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search nur-search-data; do
  git fetch origin $branch:$branch
done
