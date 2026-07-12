#!/usr/bin/env bash

set -eu
# set -x # debug

index_url=https://milahu.github.io/NUR/

cache="$HOME/.cache/nur-search/milahu.github.io/NUR/index.html"

# 24 hours
# max_cache_age=$((24 * 60 * 60))
max_cache_age=86400

if [ $# = 0 ]; then
  echo "error: no arguments"
  echo "usage: $0 some search query"
  exit 1
fi

cache_dir=${cache%/*}
# echo "cache_dir: $cache_dir"
mkdir -p "$cache_dir"

update_cache=true

if [ -e "$cache" ]; then
  cache_mtime=$(stat -c%Y "$cache") # server's last-modified time
  cache_ctime=$(stat -c%Z "$cache") # when did we last update the cache file
  cache_time=$cache_ctime
  now=$(date +%s)
  cache_age=$((now - cache_time))
  # echo "cache_time: $cache_time ($(TZ=UTC stat -c%y "$cache"))"
  # echo "now: $now ($(TZ=UTC date -Is))"
  # echo "cache_age: $cache_age"
  # echo "max_cache_age: $max_cache_age"
  if ((cache_age < max_cache_age)); then
    # echo "not updating cache"
    update_cache=false
  fi
fi

if $update_cache; then
  echo "updating cache $cache"
  pushd "$cache_dir" >/dev/null
  wget -N "$index_url"
  popd >/dev/null
fi

# Source - https://stackoverflow.com/a/29613573
# Posted by mklement0, modified by community. See post 'Timeline' for change history
# Retrieved 2026-07-12, License - CC BY-SA 4.0
quoteRe() { sed -e 's/[^^]/[&]/g; s/\^/\\^/g; $!a\'$'\n''\\n' <<<"$1" | tr -d '\n'; }

if false; then
  regex=""
  for arg in "$@"; do
    regex+=".*$(quoteRe "$arg")"
  done
  regex+=".*"
else
  regex="$1"

  if [ "${regex:0:1}" = "^" ]; then
    regex="${regex:1}"
  else
    regex=".*${regex}"
  fi

  if [ "${regex: -1}" = '$' ]; then
    regex="${regex:0: -1}"
  else
    regex="${regex}.*"
  fi
fi

# search by name
# TODO also allow search by attribute and description
grep --no-group-separator -B1 -A4 -E -i "<td n>$regex</td>" "$cache"
