# This file exists only for NUR compatibility, the main entry point is flake.nix
{ pkgs }:
let
  inherit (pkgs) lib;
  packagePaths = import ./packages;
  shelPackages = builtins.mapAttrs (
    _: path: lib.callPackageWith (pkgs // shelPackages) path { }
  ) packagePaths;
in
shelPackages
