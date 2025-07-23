{
  lib,
  runCommandLocal,
  writeText,
}:
let
  filePkg = writeText "shellvaculib.bash" (builtins.readFile ./shellvaculib.bash);
in
runCommandLocal "shellvaculib"
  {
    passthru.file = filePkg;

    meta = {
      description = "Bunch of misc shell functions I find useful";
      license = [ lib.licenses.mit ];
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      # no mainProgram
      platforms = lib.platforms.all;
    };
  }
  ''
    mkdir -p "$out"/share
    mkdir -p "$out"/bin
    ln -s ${filePkg} "$out"/share/shellvaculib.bash
    ln -s ${filePkg} "$out"/bin/shellvaculib.bash
  ''
