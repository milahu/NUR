#!/usr/bin/env bash

# format JSON files like repos.json

set -eux

command -v jq
command -v sponge # moreutils

cat "$1" |
jq --sort-keys --indent 4 |
sponge "$1"
