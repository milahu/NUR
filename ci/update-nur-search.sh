#!/usr/bin/env nix-shell
#!nix-shell --quiet -p git -p nix -p bash -i bash

# github env:
# https://docs.github.com/en/actions/learn-github-actions/variables
# GITHUB_REPOSITORY=nix-community/NUR
# GITHUB_REPOSITORY_OWNER=nix-community

# https://stackoverflow.com/a/72152879/10440128
GITHUB_REPOSITORY_NAME=${GITHUB_REPOSITORY#*/}

set -e -o pipefail # Exit with nonzero exit code if anything fails

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source ${DIR}/lib/setup-git.sh
set -x


# build package.json for nur-search
# ---------------------------------

nix build --quiet "${DIR}#"

cd "${DIR}/.."

api_user_github=$API_USER_GITHUB
if [ -z "$api_user_github" ]; then
  api_user_github=$GITHUB_REPOSITORY_OWNER
fi
echo "api_user_github: $api_user_github"



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



# nur-search

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

combined_repo_depth=${COMBINED_REPO_DEPTH:-1}
git clone \
  --depth=$combined_repo_depth \
  --single-branch \
  --branch=$combined_repo_branch \
  $combined_repo_url \
  nur-combined \
|| git -C nur-combined pull

search_repo_depth=${SEARCH_REPO_DEPTH:-1}
git clone \
  --depth=$search_repo_depth \
  --single-branch \
  --branch=$search_repo_branch \
  $search_repo_url \
  nur-search \
|| git -C nur-search pull

git -C nur-search fetch origin $search_repo_gh_pages_branch:gh-pages --depth=1



# update

nix run --quiet "${DIR}#" -- index nur-combined > nur-search/data/packages.json

# rebuild and publish nur-search repository
# -----------------------------------------

force_nur_search_update=${FORCE_NUR_SEARCH_UPDATE:-false}
cd nur-search
set +x # hide output of "git status"
if [[ ! -z "$(git status --porcelain)" ]] || $force_nur_search_update; then
    set -x
    git add ./data/packages.json
    git commit -m "automatic update package.json" || true
    # TODO dynamic branch name
    git pull --rebase origin master
    git push origin master
    echo generating html
    # run nur-search/Makefile
    nix-shell --quiet --run "make clean && make && make publish"
else
    set -x
    echo "nothings changed will not commit anything"
fi
