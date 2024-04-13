#!/bin/sh

nur_combined_blob_url='https://github.com/milahu/NUR/blob/'
nur_combined_repos_url="$nur_combined_blob_url"'nur-combined/repos/'

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
            "'$nur_combined_repos_url'" + $i.name + (
              .value.meta.position[($i.source_storepath | length):] | sub(":(?<x>[0-9]+)$"; "#L\(.x)")
            )
          ) end),
          # origin repo url
          # FIXME this only works for repos on github.com
          # gitlab and gitea have different url paths... (fuck them!!)
          _originUrl: (if .value.meta.position == null then null else (
            $i.source.url + "/blob/" + $i.source.rev + (
              .value.meta.position[($i.source_storepath | length):] | sub(":(?<x>[0-9]+)$"; "#L\(.x)")
            )
          ) end),
        })}
      ) | from_entries
    )
  )
' nur-eval-results/*.json
