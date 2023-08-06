#!/usr/bin/env nix-shell
#!nix-shell --quiet -p git -p nix -p bash -p hugo -p python3 -p python3.pkgs.requests -i bash

# TODO? make "nix run" and "nix build" faster

# TODO? use something more lightweight than hugo
# $ du -sh /nix/store/56c796m1nr81chwv54ic2rcrnc7j30z4-hugo-0.114.0
# 57M     /nix/store/56c796m1nr81chwv54ic2rcrnc7j30z4-hugo-0.114.0


# github env:
# https://docs.github.com/en/actions/learn-github-actions/variables
# GITHUB_REPOSITORY=nix-community/NUR
# GITHUB_REPOSITORY_OWNER=nix-community

# https://stackoverflow.com/a/72152879/10440128
GITHUB_REPOSITORY_NAME=${GITHUB_REPOSITORY#*/}

set -e -o pipefail # Exit with nonzero exit code if anything fails



# based on ci/lib/setup-git.sh

export GIT_AUTHOR_NAME="Nur a bot"
export GIT_AUTHOR_EMAIL="nixpkgs-review@example.com"
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# based on ci/nur/path.py
# TODO: ROOT = _find_root()
ROOT=.
LOCK_PATH=$ROOT/repos.json.lock
MANIFEST_PATH=$ROOT/repos.json
EVALREPO_PATH=$ROOT/lib/evalRepo.nix
EVAL_ERRORS_PATH=$ROOT/nur-eval-errors
EVAL_ERRORS_LOCK_PATH=$ROOT/nur-eval-errors/repos.json.lock
PREFETCH_CACHE_PATH=$ROOT/prefetch-cache.pickle

# TODO? support both versions: multirepos and monorepo-with-branches
#nur_repos_json_remote=origin
#nur_repos_json_branch=nur-repos
#nur_repos_json_path=nur-repos

# repos.json.lock
#nur_repos_json_lock_remote=origin
#nur_repos_json_lock_branch=nur-repos-lock
#nur_repos_json_lock_path=nur-repos-lock

# fetch some branches of the NUR repo
main_branch=master

# skip branches: nur-packages-template nur-update
extra_branches=(gh-pages nur-combined nur-eval-errors nur-repos nur-repos-lock nur-search)

# debug
set -x
pwd
git branch
git log --oneline



# hide password in logs
set +x

api_user_github=$API_USER_GITHUB
if [ -z "$api_user_github" ]; then
  api_user_github=$GITHUB_REPOSITORY_OWNER
  echo "using default api_user_github: $api_user_github"
fi

this_repo_url=github.com/$GITHUB_REPOSITORY

# add user and password
this_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$this_repo_url

# set user and password for "git push"
git remote set-url origin $this_repo_url

set -x



# no. main branch is fetched by .github/workflows/update.yml
#mkdir NUR
#cd NUR
#git init
#git remote add origin https://github.com/$GITHUB_REPOSITORY
#echo fetching branches: $main_branch ${extra_branches[@]}
echo fetching branches: ${extra_branches[@]}
#git fetch --depth=1 origin $main_branch ${extra_branches[@]}
time \
git fetch --depth=1 origin ${extra_branches[@]}
#echo mounting main branch: $main_branch
#git checkout $main_branch
for branch in ${extra_branches[@]}; do
  echo mounting extra branch: $branch
  git worktree add $branch $branch
done

#MANIFEST_PATH=repos.json
ln -sr nur-repos/repos.json repos.json

#LOCK_PATH=repos.json.lock
ln -sr nur-repos-lock/repos.json.lock repos.json.lock



# based on ci/update-nur.sh

# absolute path of NUR repo
DIR="$(readlink -f "$(dirname "$0")")"
NUR_REPO_PATH="$(readlink -f "$(dirname "$0")/..")"

set -x



echo running update...
time \
python3 -m ci.nur update
#nix run --quiet "$NUR_REPO_PATH/ci#" -- update

cd "$NUR_REPO_PATH"

# API_TOKEN_GITHUB needs write access to both repos
# TODO modify only the result repo

# nur-combined is already fetched
if false; then
this_repo_url=$THIS_REPO_URL
if [ -z "$this_repo_url" ]; then
  this_repo_url=github.com/$GITHUB_REPOSITORY
  echo "using default this_repo_url: $this_repo_url"
  # add user and password
  this_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$this_repo_url
fi

result_repo_url=$RESULT_REPO_URL
if [ -z "$result_repo_url" ]; then
  result_repo_url=github.com/$GITHUB_REPOSITORY_OWNER/nur-combined
  echo "using default result_repo_url: $result_repo_url"
  # add user and password
  result_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$result_repo_url
fi

result_repo_depth=${RESULT_REPO_DEPTH:-1}
time \
git clone \
  --depth=$result_repo_depth \
  --single-branch \
  $result_repo_url \
  nur-combined
fi

echo running combine...
time \
python3 -m ci.nur combine nur-combined
#nix run --quiet "$NUR_REPO_PATH/ci#" -- combine nur-combined

set +x # hide output of "git diff"
if [[ -z "$(git status --porcelain)" ]]; then
  echo "No changes to the output on this push; exiting."
  # TODO exit?
  exit
else
  set -x
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
  git -C nur-repos add repos.json
  git -C nur-repos commit -m "automatic update" || true

  git -C nur-repos-lock add repos.json.lock
  git -C nur-repos-lock commit -m "automatic update" || true

  git -C nur-eval-errors add .
  git -C nur-eval-errors commit -m "automatic update" || true

  echo fetching branches: nur-repos nur-repos-lock nur-eval-errors
  git fetch origin nur-repos nur-repos-lock nur-eval-errors --depth=1

  echo pushing branches: nur-repos nur-repos-lock nur-eval-errors
  git push origin nur-repos:nur-repos nur-repos-lock:nur-repos-lock nur-eval-errors:nur-eval-errors
  fi
fi
set -x

# FIXME remove "-C nur-combined"
if false; then
# multirepos
time \
git -C nur-combined pull --rebase origin master
time \
git -C nur-combined push origin HEAD:master
else
# monorepo-with-branches
time \
git -C nur-combined pull --rebase origin nur-combined --depth=1
time \
git push origin nur-combined:nur-combined
fi



# update search

# based on ci/update-nur-search.sh

# merged ci/update-nur-search.sh and ci/update-nur.sh
# to make the workflow run faster



# nur-search (1)

# TODO why? what?
echo building package.json for nur-search



# nur-combined

# original: https://github.com/nix-community/nur-combined
#combined_repo_url=${COMBINED_REPO_URL:-https://github.com/nix-community/nur-combined}
#combined_repo_url=$COMBINED_REPO_URL
# github
#combined_repo_owner=${COMBINED_REPO_OWNER:-nix-community}
combined_repo_owner=${COMBINED_REPO_OWNER:-$GITHUB_REPOSITORY_OWNER}
# move nur-combined repo to nur-combined branch of NUR repo
#combined_repo_name=${COMBINED_REPO_NAME:-nur-combined}
#combined_repo_branch=${COMBINED_REPO_BRANCH:-master}
#combined_repo_name=${COMBINED_REPO_NAME:-NUR}
combined_repo_name=${COMBINED_REPO_NAME:-$GITHUB_REPOSITORY_NAME}
combined_repo_branch=${COMBINED_REPO_BRANCH:-nur-combined}

combined_repo_url=github.com/$combined_repo_owner/$combined_repo_name
#$GITHUB_REPOSITORY_OWNER/nur-combined
echo "combined_repo_url: https://$combined_repo_url"

# add user and password
combined_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$combined_repo_url



# nur-search (2)
# TODO merge with nur-search (1)?

# original: https://github.com/nix-community/nur-search
#search_repo_url=$SEARCH_REPO_URL
# github
#search_repo_owner=${SEARCH_REPO_OWNER:-nix-community}
search_repo_owner=${SEARCH_REPO_OWNER:-$GITHUB_REPOSITORY_OWNER}
# move nur-search repo to nur-search branch of NUR repo
#search_repo_name=${SEARCH_REPO_NAME:-nur-search}
#search_repo_branch=${SEARCH_REPO_BRANCH:-master}
#search_repo_name=${SEARCH_REPO_NAME:-NUR}
search_repo_name=${SEARCH_REPO_NAME:-$GITHUB_REPOSITORY_NAME}
search_repo_branch=${SEARCH_REPO_BRANCH:-nur-search}
search_repo_gh_pages_branch=${SEARCH_REPO_BRANCH:-gh-pages}

search_repo_url=github.com/$search_repo_owner/$search_repo_name
echo "search_repo_url: https://$search_repo_url"

# add user and password
search_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$search_repo_url



# clone

# branches are already fetched: nur-combined nur-search gh-pages
if false; then
combined_repo_depth=${COMBINED_REPO_DEPTH:-1}
time \
git clone \
  --depth=$combined_repo_depth \
  --single-branch \
  --branch=$combined_repo_branch \
  $combined_repo_url \
  nur-combined \
|| git -C nur-combined pull

search_repo_depth=${SEARCH_REPO_DEPTH:-1}
time \
git clone \
  --depth=$search_repo_depth \
  --single-branch \
  --branch=$search_repo_branch \
  $search_repo_url \
  nur-search \
|| git -C nur-search pull

# FIXME remove "-C nur-search"
time \
git -C nur-search fetch origin $search_repo_gh_pages_branch:gh-pages --depth=1
fi



# update

echo running index...
time \
python3 -m ci.nur index nur-combined > nur-search/data/packages.json
#nix run --quiet "$NUR_REPO_PATH/ci#" -- index nur-combined > nur-search/data/packages.json

# rebuild and publish nur-search repository
# -----------------------------------------

force_nur_search_update=${FORCE_NUR_SEARCH_UPDATE:-false}
set +x # hide output of "git status"
if [[ ! -z "$(git -C nur-search status --porcelain)" ]] || $force_nur_search_update; then
    set -x
    time \
    git -C nur-search add ./data/packages.json
    time \
    git -C nur-search commit -m "automatic update package.json" || true
    # TODO dynamic branch name
    if false; then
    # multirepos
    time \
    git -C nur-search pull --rebase origin master
    time \
    git -C nur-search push origin master
    else
    # monorepo-with-branches
    time \
    git -C nur-search pull --rebase origin nur-search --depth=1
    time \
    git -C nur-search push origin nur-search
    fi

    echo generating html

    cd nur-search # TODO avoid?
    # install packages in nur-search/default.nix: hugo
    # run nur-search/Makefile
    #time \
    #nix-shell --quiet --run "make clean && make && make publish"



    # based on nur-search/Makefile

    # public:
    # debug
    set -x
    pwd
    ls
    stat public || true # stat: cannot statx 'public': No such file or directory
    #
    echo mounting gh-pages branch to public/
    # TODO why prune?
    #git worktree prune
    # no: fatal: 'gh-pages' is already checked out at '/home/runner/work/NUR/NUR/gh-pages'
    #git worktree add public gh-pages
    ln -s ../gh-pages public

    # all: public
    echo generating md files in content/
    ./scripts/generate_pages.py
    find content/ -type f

    echo cleaning public/
    rm -rf public/*
    ls -A public/

    echo generating html files in public/
    # FIXME: WARN  found no layout file for "html" for kind "page": You should create a template file which matches Hugo Layouts Lookup Rules for this combination.
    time \
    hugo
    find public/ -type f

    echo committing html files in public/
    git -C public add --all
    git -C public commit -m "Publishing to gh-pages" || true

    # publish:
    echo pushing gh-pages branch
    git -C public push origin gh-pages

    # clean:
    #echo removing public/
    #rm -rf public



    cd ..
else
    set -x
    echo "nothings changed will not commit anything"
fi
