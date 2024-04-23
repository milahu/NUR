{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  #hyprwayland-scanner = pkgs.callPackage 
in
pkgs.hyprland.overrideAttrs (
  prev: rec {
    inherit (sources.hyprland) version src;
  }
)
