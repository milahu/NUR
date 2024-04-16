{ pkgs ? import <nixpkgs> { } }:

rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  cups-detonger = pkgs.callPackage ./pkgs/cups-detonger { };
  snipaste = pkgs.callPackage ./pkgs/snipaste { };
  safeheron-crypto-suites = pkgs.callPackage ./pkgs/safeheron-crypto-suites { };
  multi-party-sig = pkgs.callPackage ./pkgs/multi-party-sig { safeheron-crypto-suites = safeheron-crypto-suites; };
  orca-slicer = pkgs.callPackage ./pkgs/orca-slicer { };
  snips-sh = pkgs.callPackage ./pkgs/snips.sh { };
}