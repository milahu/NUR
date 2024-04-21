#!/usr/bin/env bash

remote=https://github.com/milahu/NUR
branch=nur-packages-template
dst="${1:-nur-packages}"

set -e

git clone $remote --branch nur-packages-template --depth=1 $dst

cd $dst
rev=$(git rev-parse HEAD)
date=$(git log -n1 --format=%aI)

msg="$(
cat <<EOF
init from nur-packages-template

remote: $remote
branch: $branch
rev: $rev
date: $date
EOF
)"

# remove history, init new repo
rm -rf .git
git init
git add .
git commit --quiet -m "$msg"

git remote add github https://github.com/$USER/nur-packages
#git push github -u main

echo "done $dst"
