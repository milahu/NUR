let
  directoryListing = builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ];
  packagePaths = builtins.mapAttrs (
    k: v:
    assert v == "directory";
    ./${k}/module.nix
  ) directoryListing;
in
packagePaths
