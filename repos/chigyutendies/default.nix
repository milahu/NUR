# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

#  example-package = pkgs.callPackage ./pkgs/example-package { };
  yuzu-mainline = pkgs.callPackage ./pkgs/yuzu {
    branch = "mainline";
  };
  yuzu-early-access = pkgs.callPackage ./pkgs/yuzu {
    branch = "early-access";
  };
  citra-canary = pkgs.callPackage ./pkgs/citra {
    branch = "canary";
  };

  citra-nightly = pkgs.callPackage ./pkgs/citra {
    branch = "nightly";
  };
  suyu-dev = pkgs.callPackage ./pkgs/suyu {
    branch = "dev";
  };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
