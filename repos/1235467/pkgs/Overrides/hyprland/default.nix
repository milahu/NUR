{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.hyprland.overrideAttrs (
  prev: rec {
    inherit (sources.hyprland) version src;
  }
)
