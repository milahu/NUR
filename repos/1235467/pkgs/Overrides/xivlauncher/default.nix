{ stdenv
, pkgs
, lib
, ...
}:
pkgs.xivlauncher.overrideAttrs (
  final: prev: rec {
    pname = "xivlauncher-cn";
    version = "1.1.2.5";
    src = pkgs.fetchFromGitHub {
      owner = "ottercorp";
      repo = "XIVLauncher.Core";
      rev = version;
      hash = "sha256-x7Mytg/LaDMEo+HwaM5zsg1MFrmYBXCY4+rhGRaEpro=";
      fetchSubmodules = true;
    };
    nugetDeps = ./deps.json;
  }
)
