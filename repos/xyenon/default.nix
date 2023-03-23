# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  go-check = pkgs.callPackage ./pkgs/go-check { buildGoModule = pkgs.buildGo118Module; };
  lux = pkgs.callPackage ./pkgs/lux { buildGoModule = pkgs.buildGo118Module; };
  catp = pkgs.callPackage ./pkgs/catp { };
  github-copilot-cli = pkgs.callPackage ./pkgs/github-copilot-cli { };
}
