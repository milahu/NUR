#! /usr/bin/env bash

source "$(dirname "$0")"/.common.sh

set -ux

for branch in ${git_branches[@]}; do
  git fetch origin $branch:$branch
done
