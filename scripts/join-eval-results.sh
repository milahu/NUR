#!/bin/sh

cd "$(dirname "$0")/.."

# no. use relative links with <base href="https://github.com/milahu/NUR/blob/nur-combined/repos/">

#nur_combined_blob_url='https://github.com/milahu/NUR/blob/'
#nur_combined_repos_url="$nur_combined_blob_url"'nur-combined/repos/'

nur_combined_blob_url=''
nur_combined_repos_url=''

jq -c -n '
  reduce inputs as $i (
    {};
    . += (
      $i.packages | to_entries | map(
        {key: ("nur.repos." + $i.name + "." + .key), value: (.value + {
          # nur-combined url
          _nurUrl: (if .value.meta.position == null then null else (
            #"'$nur_combined_repos_url'" + $i.name + "/" + .value.meta.position[($i.source_storepath | length):]
            # no. permalinks produce too much diff noise in gh-pages
            #"'$nur_combined_blob_url'" + $i.nur_combined_rev + "/repos/" + $i.name + (
            "'$nur_combined_repos_url'" + $i.name + "/" + (
              .value.meta.position | sub(":(?<line>[0-9]+)$"; "#L\(.line)")
            )
          ) end),
          # origin repo url
          # FIXME this only works for repos on github.com
          # gitlab and gitea have different url paths... (fuck them!!)
          _originUrl: (
            if .value.meta.position == null then null else (
              .value.meta.position | sub(":(?<line>[0-9]+)$"; "#L\(.line)") | (
                if .[0:2] == "./" then ($i.source.url + "/blob/" + $i.source.rev + "/" + .[2:])
                # FIXME use nixpkgs rev instead of "master"
                elif .[0:12] == "<nixpkgs> + " then ("https://github.com/NixOS/nixpkgs/blob/master" + .[12:])
                else ($i.source.url + "/blob/" + $i.source.rev + "/" + .)
                end
              )
            )
            end
          ),
        })}
      ) | from_entries
    )
  )
' nur-eval-results/*.json
