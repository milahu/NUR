{ ... }@passedArgs:
let
  lib = passedArgs.lib or passedArgs.pkgs.lib;
  args = passedArgs // {
    inherit lib vaculib;
  };
  directoryListing = builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ];
  filePaths = lib.mapAttrsToList (
    k: v:
    assert v == "regular";
    ./${k}
  ) directoryListing;
  functionSets = map (path: import path args) filePaths;
  vaculib = lib.mergeAttrsList functionSets;
in
vaculib
