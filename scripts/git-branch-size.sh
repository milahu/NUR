#!/usr/bin/env bash

# https://stackoverflow.com/questions/32557849

git for-each-ref --format='%(refname)' |
grep ^refs/heads/ |
grep -v -E '^refs/heads/(bak|trash)-' |
while read branch
do
    # root_commit=$(git log --reverse --format=%H $branch | head -n1)
    size=$(
        # wrong! this would exclude the first commit = off-by-one error
        # git rev-list --disk-usage --objects $root_commit..$branch |
        git rev-list --disk-usage --objects $branch |
        LC_ALL=C numfmt --to=iec-i --suffix=B --format=%.2f
    )
    branch=${branch:11}
    echo $size$'\t'$branch
done |
LC_ALL=C sort -h
