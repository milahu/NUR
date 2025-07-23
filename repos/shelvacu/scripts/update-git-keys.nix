{
  config,
  writers,
  curl,
  lib,
  ...
}:
writers.writeBashBin "update-git-keys" ''
  set -xev
  domain="$1"
  api_key="$(${lib.getExe config.vacu.wrappedSops} --extract '["'$domain'"]' -d ${../secrets/misc/git-keys.json})"
  if [ $domain = github.com ]; then
    url_base="https://api.github.com"
  elif [ $domain = gitlab.com ]; then
    url_base="https://$domain/api/v4"
  elif [ $domain = sr.ht ]; then
    url_bash="https://meta.sr.ht/api"
  else
    url_base="https://$domain/api/v1"
  fi

  if [ $domain = sr.ht ]; then
    url_keys="$url_base/user/ssh-keys"
  else
    url_keys="$url_base/user/keys"
  fi

  if [ $domain = "git.uninsane.org" ] || [ $domain = "sr.ht" ] || [ $domain = git.for.miras.pet ]]; then
    authorization_name="token"
  else
    authorization_name="Bearer"
  fi

  curl_common=( \
    ${lib.getExe curl} \
    --fail \
    --header "Authorization: $authorization_name $api_key" \
    --header "Content-Type: application/json" \
  )
  if [ $domain = "github.com" ]; then
    curl_common+=(\
      --header "Accept: application/vnd.github+json" \
      --header "X-GitHub-Api-Version: 2022-11-28" \
    )
  fi
  # declare -p curl_common
  echo GET "$url_keys"
  resp="$("''${curl_common[@]}" "$url_keys")"
  for url in $(printf '%s' "$resp" | jq .[].url -r); do
    echo DELETE "$url"
    "''${curl_common[@]}" "$url" -X DELETE
  done

  new_keys=(${
    lib.escapeShellArgs (
      lib.mapAttrsToList (
        label: sshKey:
        builtins.toJSON {
          key = sshKey;
          title = label;
        }
      ) config.vacu.ssh.authorizedKeys
    )
  })
  for keydata in "''${new_keys[@]}"; do
    echo POST "$api_keys"
    "''${curl_common[@]}" "$url_keys" -X POST --data "$keydata"
  done
''
