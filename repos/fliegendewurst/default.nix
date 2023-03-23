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

  diskgraph = pkgs.callPackage ./pkgs/diskgraph { };
  freqtop = pkgs.callPackage ./pkgs/freqtop { };
  map = pkgs.callPackage ./pkgs/map { };
  q = pkgs.callPackage ./pkgs/q { };
  raspi-oled = pkgs.callPackage ./pkgs/raspi-oled { };
  raspi-oled-cross = pkgs.pkgsCross.muslpi.callPackage ./pkgs/raspi-oled { };
  ripgrep-all = pkgs.callPackage ./pkgs/ripgrep-all {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
