{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.onnxruntime.overrideAttrs (
  prev: rec {
    version = "1.18.0";
    src = pkgs.fetchFromGitHub {
      owner = "microsoft";
      repo = "onnxruntime";
      rev = "refs/tags/v${version}";
      hash = "sha256-kYjrHxmJrD2yBftyWWqKDUjgMk1tpYxJIgFMHKi/JTI=";
      fetchSubmodules = true;
    };
  }
)
