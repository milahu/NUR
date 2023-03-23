#!/usr/bin/env nix-shell
#!nix-shell --quiet -p git -p nix -p bash -i bash

set -eu -o pipefail # Exit with nonzero exit code if anything fails

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
  echo "using default api_user_github: $api_user_github"
fi

# original: https://github.com/nix-community/nur-combined
combined_repo_url=$COMBINED_REPO_URL
if [ -z "$combined_repo_url" ]; then
  combined_repo_url=github.com/$GITHUB_REPOSITORY_OWNER/nur-combined
  echo "using default combined_repo_url: $combined_repo_url"
  combined_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$combined_repo_url
fi

# original: https://github.com/nix-community/nur-search
search_repo_url=$SEARCH_REPO_URL
if [ -z "$search_repo_url" ]; then
  search_repo_url=github.com/$GITHUB_REPOSITORY_OWNER/nur-search
  echo "using default search_repo_url: $search_repo_url"
  search_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$search_repo_url
fi

combined_repo_depth=${COMBINED_REPO_DEPTH:-1}
git clone \
  --depth=$combined_repo_depth \
  --single-branch \
  $combined_repo_url \
  nur-combined \
|| git -C nur-combined pull

search_repo_depth=${SEARCH_REPO_DEPTH:-1}
git clone \
  --depth=$search_repo_depth \
  --single-branch \
  $search_repo_url \
  nur-search \
|| git -C nur-search pull

nix run --quiet "${DIR}#" -- index nur-combined > nur-search/data/packages.json

# rebuild and publish nur-search repository
# -----------------------------------------

cd nur-search
set +x # hide output of "git status"
if [[ ! -z "$(git status --porcelain)" ]]; then
    set -x
    git add ./data/packages.json
    git commit -m "automatic update package.json"
    git pull --rebase origin master
    git push origin master
    nix-shell --run "make clean && make && make publish"
else
    set -x
    echo "nothings changed will not commit anything"
fi
