let
  directoryListing = builtins.removeAttrs (builtins.readDir ./.) [ "default.nix" ];
  packagePaths = builtins.mapAttrs (
    k: v:
    assert v == "directory";
    ./${k}/package.nix
  ) directoryListing;
in
packagePaths
