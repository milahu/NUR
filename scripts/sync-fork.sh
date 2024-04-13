#!/usr/bin/env bash

set -e
set -x

branch=upstream-nur-master
remote_name=upstream-nur
remote_url=https://github.com/nix-community/NUR
remote_branch=master

git remote add $remote_name $remote_url ||
  git remote set-url $remote_name $remote_url

if ! [ -d $branch ]; then
  # init from remote
  git fetch $remote_name $remote_branch:$branch
  git worktree add $branch $branch
else
  # update from remote
  git_status=$(git -C $branch status --porcelain=v1)
  if [ -n "$git_status" ]; then
    echo "error: branch is dirty: $branch"
    echo "$git_status"
    exit 1
  fi
  git -C $branch pull $remote_name $remote_branch
fi

date_str=$(date --utc +%Y%m%dT%H%M%SZ)
rand_str=$(mktemp -u XXXXXXXXXX)

# keep only repos.json in nur-repos branch history
new_branch=nur-repos

# TODO check if update is necessry
# git log $new_branch --

new_branch_bak=${new_branch}_${date_str}_bak
new_branch_tmp=${new_branch}_${date_str}

git branch --copy $branch $new_branch_tmp
git filter-repo --path repos.json --refs $new_branch_tmp --force

#worktree_path=$(git worktree list | grep "\[$new_branch\]\$" | cut -d' ' -f1)
if [ -d $new_branch ]; then
  # this fails if the worktree is dirty
  git worktree $new_branch
fi

git branch --move $new_branch $new_branch_bak
git branch --move $new_branch_tmp $new_branch



echo asdf
exit

#### move repos.json.lock to a separate branch: nur-repos-lock

# create backup of master branch
git branch --copy master master-bak-with-nur-repos-lock

# create nur-repos-lock branch
git branch --copy master nur-repos-lock

# remove repos.json.lock from master branch history
git filter-repo --invert-paths --path repos.json.lock --refs master --force

# keep only repos.json.lock in nur-repos-lock branch history
git filter-repo --path repos.json.lock --refs nur-repos-lock --force




#### move repos.json to a separate branch: nur-repos

# create backup of master branch
git branch --copy master master-bak-with-nur-repos

# create nur-repos branch
git branch --copy master nur-repos

# remove repos.json from master branch history
git filter-repo --invert-paths --path repos.json --refs master --force

# keep only repos.json in nur-repos branch history
git filter-repo --path repos.json --refs nur-repos --force



#### move eval-errors/ to a separate branch: nur-eval-errors

# create backup of master branch
git branch --copy master master-bak-with-nur-eval-errors

# create nur-eval-errors branch
git branch --copy master nur-eval-errors

# remove eval-errors/ from master branch history
git filter-repo --invert-paths --path eval-errors/ --refs master --force

# keep only eval-errors/ in nur-eval-errors branch history
git filter-repo --path eval-errors/ --refs nur-eval-errors --force



#### remove moved files from branches based on master branch

for branch in parallel-fetch python37 quiet-builds; do
  # create backup branch
  git branch --copy $branch $branch-with-removed-files

  # remove files
  git filter-repo --invert-paths --path repos.json.lock --refs $branch --force
  git filter-repo --invert-paths --path repos.json --refs $branch --force
  git filter-repo --invert-paths --path eval-errors/ --refs $branch --force
done



#### nur-search: move data/ to a separate branch: nur-search-data

# this will take some time...
git fetch https://github.com/nix-community/nur-search master:upstream-nur-search

# create nur-search-data branch
git branch --copy upstream-nur-search nur-search-data

# keep only data/ in nur-search-data branch history
git filter-repo --path data/ --refs nur-search-data --force

# create nur-search branch
git branch --move nur-search nur-search-bak
git branch --copy upstream-nur-search nur-search

# remove data/ from nur-search branch history
git filter-repo --invert-paths --path data/ --refs nur-search --force



### move everything to one repo

git remote add nur-search-repo https://github.com/milahu/nur-search
git fetch nur-search-repo master:nur-search
git fetch nur-search-repo gh-pages:gh-pages

git remote add nur-combined-repo https://github.com/milahu/nur-combined
git fetch nur-combined-repo master:nur-combined

git remote add nur-update-repo https://github.com/nix-community/nur-update
git fetch nur-update-repo master:nur-update

git remote add nur-packages-template-repo https://github.com/nix-community/nur-packages-template
git fetch nur-packages-template-repo master:nur-packages-template
