# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage recurseIntoAttrs;
in
rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # Dev utils
  fetchDenoTarball = callPackage ./pkgs/deno-extra/fetchDenoTarball.nix { };
  bundleDeno = callPackage ./pkgs/deno-extra/bundleDeno.nix { inherit fetchDenoTarball; };

  bane = callPackage ./pkgs/bane { };
  conform = callPackage ./pkgs/conform { };
  container-diff = callPackage ./pkgs/container-diff { };
  hasklig-nerdfont = pkgs.nerdfonts.override { fonts = [ "Hasklig" ]; };
  kdigger = callPackage ./pkgs/kdigger { };
  kubernetes-bom = callPackage ./pkgs/kubernetes-bom { };
  tuftool = callPackage ./pkgs/tuftool { };
}
