# only source this file
# ==================================================

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
EVAL_ERRORS_PATH=$ROOT/eval-errors
EVAL_ERRORS_LOCK_PATH=$ROOT/eval-errors/repos.json.lock
PREFETCH_CACHE_PATH=$ROOT/prefetch-cache.pickle

nur_repos_json_remote=origin
nur_repos_json_branch=nur-repos
nur_repos_json_path=nur-repos

# repos.json.lock
nur_repos_json_lock_remote=origin
nur_repos_json_lock_branch=nur-repos-lock
nur_repos_json_lock_path=nur-repos-lock

# fix: FileNotFoundError: [Errno 2] No such file or directory: '/home/runner/work/NUR/NUR/repos.json'
if ! [ -e "$MANIFEST_PATH" ]; then
  echo fetching $MANIFEST_PATH
  set -x
  git fetch $nur_repos_json_remote $nur_repos_json_branch
  git worktree add $nur_repos_json_path $nur_repos_json_branch
  ln -sr $nur_repos_json_path/repos.json $MANIFEST_PATH
  set +x
fi

# fix: ERROR:nur.update:repository milahu failed to evaluate, This repo is not yet in our lock file!!!!
if ! [ -e "$LOCK_PATH" ]; then
  echo fetching $LOCK_PATH
  set -x
  git fetch $nur_repos_json_lock_remote $nur_repos_json_lock_branch
  git worktree add $nur_repos_json_lock_path $nur_repos_json_lock_branch
  ln -sr $nur_repos_json_lock_path/repos.json.lock $LOCK_PATH
  set +x
fi
