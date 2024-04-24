{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  hyprwayland-scanner = pkgs.callPackage ./hyprwayland-scanner.nix {};
in
pkgs.hyprland.overrideAttrs (
  prev: rec {
    inherit (sources.hyprland) version src;
    nativeBuidInputs = prev.nativeBuildInputs  ++  [hyprwayland-scanner];
    buidInputs = prev.buildInputs  ++  [hyprwayland-scanner pkgs.cmake];
  }
)
