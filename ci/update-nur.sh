#!/usr/bin/env nix-shell
#!nix-shell --quiet -p git -p nix -p bash -i bash

set -e -o pipefail # Exit with nonzero exit code if anything fails


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source ${DIR}/lib/setup-git.sh
set -x

nix run --quiet "${DIR}#" -- update

cd ${DIR}/..

# API_TOKEN_GITHUB needs write access to both repos
# TODO modify only the result repo

api_user_github=$API_USER_GITHUB
if [ -z "$api_user_github" ]; then
  api_user_github=$GITHUB_REPOSITORY_OWNER
  echo "using default api_user_github: $api_user_github"
fi

this_repo_url=$THIS_REPO_URL
if [ -z "$this_repo_url" ]; then
  this_repo_url=github.com/$GITHUB_REPOSITORY
  echo "using default this_repo_url: $this_repo_url"
  this_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$this_repo_url
fi

result_repo_url=$RESULT_REPO_URL
if [ -z "$result_repo_url" ]; then
  result_repo_url=github.com/$GITHUB_REPOSITORY_OWNER/nur-combined
  echo "using default result_repo_url: $result_repo_url"
  result_repo_url=https://$api_user_github:$API_TOKEN_GITHUB@$result_repo_url
fi

result_repo_depth=${RESULT_REPO_DEPTH:-1}
git clone \
  --depth=$result_repo_depth \
  --single-branch \
  $result_repo_url \
  nur-combined

nix run --quiet "${DIR}#" -- combine nur-combined

set +x # hide output of "git diff"
if [[ -z "$(git status --porcelain)" ]]; then
  echo "No changes to the output on this push; exiting."
else
  set -x
  git add --all repos.json*
  git add eval-errors/
  git commit -m "automatic update"
  # in case we are getting overtaken by a different job
  git pull --rebase origin master
  git push $this_repo_url HEAD:master
fi
set -x

git -C nur-combined pull --rebase origin master
git -C nur-combined push $result_repo_url HEAD:master
