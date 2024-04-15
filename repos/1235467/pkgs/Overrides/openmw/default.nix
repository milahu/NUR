{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.openmw.overrideAttrs (
  prev: rec {
    inherit (sources.openmw) version src;
    buildInputs = prev.buildInputs ++ (with pkgs; [libsForQt5.qt5.qttools collada]);
  }
)
