{ lib
, resholve

  # Dependencies
, bash
, coreutils
, gawk
}:

let
  inherit (builtins) readFile;
  inherit (lib) getExe;
in
resholve.writeScriptBin "jj-dynamic-default-description" {
  interpreter = getExe bash;
  inputs = [ coreutils gawk ];
} (readFile ./assets/jj-dynamic-default-description.sh)
