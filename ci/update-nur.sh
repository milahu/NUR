#!/usr/bin/env bash

echo ci/update-nur.sh: start time: $(date +"%F %T.%N")

# check dependencies
for bin in git nix python3 jq rsync nix-prefetch-git nix-prefetch-url; do
  if ! command -v $bin >/dev/null; then
    echo "error: missing dependency: $bin"
    exit 1
  fi
done

# absolute path of NUR repo
NUR_CI_PATH="$(readlink -f "$(dirname "$0")")"
NUR_REPO_PATH="$(readlink -f "$(dirname "$0")/..")"

# github env:
# https://docs.github.com/en/actions/learn-github-actions/variables
# GITHUB_REPOSITORY=nix-community/NUR
# GITHUB_REPOSITORY_OWNER=nix-community

# https://stackoverflow.com/a/72152879/10440128
GITHUB_REPOSITORY_NAME=${GITHUB_REPOSITORY#*/}

set -e -o pipefail # Exit with nonzero exit code if anything fails

#set -x # debug

# based on ci/lib/setup-git.sh

export GIT_AUTHOR_NAME="Nur a bot"
export GIT_AUTHOR_EMAIL="nixpkgs-review@example.com"
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# based on ci/nur/path.py
# TODO: ROOT = _find_root()
ROOT=.
export LOCK_PATH=$ROOT/repos.json.lock
export MANIFEST_PATH=$ROOT/repos.json
export EVALREPO_PATH=$ROOT/lib/evalRepo.nix
export EVAL_ERRORS_PATH=$ROOT/nur-eval-errors
export EVAL_RESULTS_PATH=$ROOT/nur-eval-results
export EVAL_ERRORS_LOCK_PATH=$ROOT/nur-eval-errors/repos.json.lock
export PREFETCH_CACHE_PATH=$ROOT/prefetch-cache.pickle
export COMBINED_REPOS_PATH=$ROOT/nur-combined

# branches of the NUR repo
main_branch=master
extra_branches=(gh-pages nur-combined nur-eval-results nur-eval-errors nur-repos nur-repos-lock nur-search-html)

# required envs
if ! [ -v API_TOKEN_GITHUB ]; then echo "error: missing env API_TOKEN_GITHUB"; exit 1; fi

# optional envs
if ! [ -v GITHUB_REPOSITORY_OWNER ]; then GITHUB_REPOSITORY_OWNER=milahu; fi
if ! [ -v GITHUB_REPOSITORY ]; then GITHUB_REPOSITORY=$GITHUB_REPOSITORY_OWNER/NUR; fi
if ! [ -v API_USER_GITHUB ]; then API_USER_GITHUB=$GITHUB_REPOSITORY_OWNER; fi

this_repo_url=github.com/$GITHUB_REPOSITORY

# hide password in logs
# todo: restore "set -x"
set +x

# add user and password
# if the github API token has expired, with the token-as-username login, git will ask for a password.
# if the github API token has expired, with the token-as-passoword login, git will say
# remote: Support for password authentication was removed on August 13, 2021.
# these are bugs in github.
this_repo_url=https://$API_USER_GITHUB:$API_TOKEN_GITHUB@$this_repo_url

# set user and password for "git push"
git remote set-url origin $this_repo_url



echo fetching branches: ${extra_branches[@]}
#git fetch --depth=1 origin $main_branch ${extra_branches[@]}
branch_args=()
for branch in ${extra_branches[@]}; do
  #branch_args+=($branch:$branch)
  branch_args+=($branch)
done
time \
git fetch --depth=1 origin ${branch_args[@]}

#echo mounting main branch: $main_branch
#git checkout $main_branch
for branch in ${extra_branches[@]}; do
  if [ -e $branch ]; then
    # check if this dir is a mounted git worktree
    worktree_path=$(readlink -f "$PWD/$branch")
    if git worktree list | grep -q "^$worktree_path "; then
      git -C $branch reset --hard HEAD
      git -C $branch clean -fdx
      continue
    fi
    echo "error: path exists: $PWD/$branch"
    exit 1
  fi
  echo mounting extra branch: $branch
  git worktree add $branch $branch

  # no. avoid gitmodules. keep everything in this repo
  # fetch submodules
  # nur-search has a git module for hugo theme
  #git -C $branch submodule update --init --depth=1 --recursive
done

# unmount branch:
# git -C $branch submodule deinit --all --force
# git worktree remove $branch --force

#MANIFEST_PATH=repos.json
ln -sr nur-repos/repos.json repos.json || true

#LOCK_PATH=repos.json.lock
ln -sr nur-repos-lock/repos.json.lock repos.json.lock || true




echo running update...
time \
python3 -m ci.nur.__init__ update



echo building gh-pages

./nur-search-html/build.sh <(./scripts/join-eval-results.sh) >gh-pages/index.html
rsync ./nur-search-html/tablefilter.min.* ./gh-pages/

if false; then
  # multirepos
  git add --all repos.json*
  git add nur-eval-errors/
  git commit -m "automatic update"
  # in case we are getting overtaken by a different job
  time \
  git pull --rebase origin master
  time \
  git push $this_repo_url HEAD:master
else
  # monorepo with branches
  git -C nur-repos add repos.json
  git -C nur-repos commit -m "automatic update" || true

  git -C nur-repos-lock add repos.json.lock
  git -C nur-repos-lock commit -m "automatic update" || true

  for branch in nur-eval-errors nur-eval-results gh-pages; do
    git -C $branch add .
    git -C $branch commit -m "automatic update" || true
  done

  # TODO earlier?
  #echo fetching branches: nur-repos nur-repos-lock nur-eval-errors gh-pages
  #git fetch --depth=1 origin nur-repos nur-repos-lock nur-eval-errors gh-pages nur-combined

  branches="nur-repos nur-repos-lock nur-eval-errors gh-pages nur-combined"
  echo pushing branches: $branches
  git push origin $branches
fi

# TODO remove?
if false; then
# FIXME remove "-C nur-combined"
if false; then
  # multirepos
  time \
  git -C nur-combined pull --rebase origin master
  time \
  git -C nur-combined push origin HEAD:master
else
# monorepo with branches
  time \
  git -C nur-combined pull --rebase origin nur-combined --depth=1
  time \
  git push origin nur-combined:nur-combined
fi
fi



# debug
echo ci/update-nur.sh: end time: $(date +"%F %T.%N")
