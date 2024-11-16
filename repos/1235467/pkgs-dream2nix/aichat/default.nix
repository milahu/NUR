{
  lib,
  config,
  dream2nix,
  pkgs,
  ...
}: 
let 
  sources = pkgs.callPackage ../../_sources/generated.nix { };
in rec {
  imports = [
    dream2nix.modules.dream2nix.rust-cargo-lock
    dream2nix.modules.dream2nix.rust-crane
  ];

  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) fetchFromGitHub iconv;
  };

  name = "aichat";
  version = "0.23.0";

  # options defined on top-level will be applied to the main derivation (the derivation that is exposed)
  mkDerivation = {
    # define the source root that contains the package we want to build.
    src = config.deps.fetchFromGitHub {
      owner = "sigoden";
      repo = "aichat";
      rev = "v${version}";
      sha256 = "sha256-75KL1ODA+HyG/YRQIDs3++RgxQHyxKj6zh/2f6zQbdY=";
    };
    buildInputs = lib.optionals config.deps.stdenv.isDarwin [config.deps.iconv];
  };

  rust-crane = {
    buildProfile = "dev";
    buildFlags = ["--verbose"];
    runTests = false;
    depsDrv = {
      # options defined here will be applied to the dependencies derivation
    };
  };
}


