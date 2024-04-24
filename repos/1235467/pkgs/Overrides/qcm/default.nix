{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.qcm.overrideAttrs (
  prev: rec {
    inherit (sources.qcm) version src;
  }
)
