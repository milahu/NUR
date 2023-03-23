#!/usr/bin/env nix-shell
#!nix-shell -p git -p nix -p bash -i bash

set -eu -o pipefail # Exit with nonzero exit code if anything fails


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source ${DIR}/lib/setup-git.sh
set -x

nix run "${DIR}#" -- update

cd ${DIR}/..

# API_TOKEN_GITHUB needs write access to both repos
# TODO modify only the result repo

this_repo_url=$THIS_REPO_URL
if [ -z "$this_repo_url" ]; then
  this_repo_url=github.com/$GITHUB_REPOSITORY
  echo "using default this_repo_url: $this_repo_url"
  this_repo_url=https://$API_TOKEN_GITHUB@$this_repo_url
fi

result_repo_url=$RESULT_REPO_URL
if [ -z "$result_repo_url" ]; then
  result_repo_url=github.com/$GITHUB_REPOSITORY_OWNER/nur-combined
  echo "using default result_repo_url: $result_repo_url"
  result_repo_url=https://$API_TOKEN_GITHUB@$result_repo_url
fi

git clone \
  --single-branch \
  $result_repo_url \
  nur-combined

nix run "${DIR}#" -- combine nur-combined

if [[ -z "$(git diff --exit-code)" ]]; then
  echo "No changes to the output on this push; exiting."
else
  git add --all repos.json*
  git add eval-errors/
  git commit -m "automatic update"
  # in case we are getting overtaken by a different job
  git pull --rebase origin master
  git push $this_repo_url HEAD:master
fi

git -C nur-combined pull --rebase origin master
git -C nur-combined push origin HEAD:master
