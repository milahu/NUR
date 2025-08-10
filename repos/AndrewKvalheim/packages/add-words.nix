{ lib
, resholve

  # Dependencies
, bash
, coreutils
, git
, jujutsu
, moreutils
}:

let
  inherit (builtins) readFile;
  inherit (lib) getExe;
in
resholve.writeScriptBin "add-words" {
  interpreter = getExe bash;
  inputs = [ coreutils git jujutsu moreutils ];
  execer = [
    "cannot:${getExe git}"
    "cannot:${getExe jujutsu}"
  ];
} (readFile ./resources/add-words)
