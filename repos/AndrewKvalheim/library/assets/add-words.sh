#!/usr/bin/env bash
set -Eeuo pipefail

cd "$HOME/src/configuration"

message='Update spell check word list'
txt='components/assets/words.txt'

add_words() {
  printf '%s\n' "$@" | sort "$txt" - | uniq | sponge "$txt"
}

find_change() {
  jj log --color 'never' --no-graph --limit '1' --revisions "$1" --template 'self.change_id()'
}

if [[ -d '.jj' ]]; then
  current_change="$(find_change '@')"

  reused_change="$(find_change "main+:: & description(exact:\"$message\n\")")"
  if [[ -n "$reused_change" ]]; then
    jj --quiet new "$reused_change"
  else
    jj --quiet new --after 'main' --message "$message"
  fi

  add_words "$@"

  if [[ -n "$(find_change '@ & empty()')" ]]; then
    echo 'No changes' >&2
    jj --quiet undo '@'
  else
    jj --no-pager diff --revisions '@'

    if [[ -n "$reused_change" ]]; then
      jj --quiet squash
    fi

    jj --quiet edit "$current_change"
  fi
else
  if [[ -n "$(git status --porcelain "$txt")" ]]; then
    echo "Error: Existing uncommitted changes to $txt" >&2
    exit 1
  fi

  if [[ -n "$(git diff --cached --name-only)" ]]; then
    echo "Error: Existing staged changes" >&2
    exit 1
  fi

  add_words "$@"

  git add "$txt"
  if [[ "$(git log -1 --pretty='%s')" == "$message" ]] && ! git merge-base --is-ancestor 'HEAD' '@{u}'; then
    git commit --amend --no-edit
  else
    git commit --message "$message"
  fi
  git show HEAD
fi
