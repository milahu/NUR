# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

{  
  example-package = pkgs.callPackage ./pkgs/example-package { };
  helloworld = pkgs.callPackage ./pkgs/helloworld { };

  PF-LT = pkgs.callPackage ./pkgs/PF-LT {};
  ALM1 = pkgs.callPackage ./pkgs/ALM1 {};
  PS = pkgs.callPackage ./pkgs/PS {};
  TS = pkgs.callPackage ./pkgs/TS {};
}