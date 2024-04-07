#!/bin/sh

jq -c -n '
  reduce inputs as $i (
    {};
    . += (
      $i.packages | to_entries | map(
        {key: ("nur.repos." + $i.name + "." + .key), value: .value}
      ) | from_entries
    )
  )
' nur-eval-results/*.json
