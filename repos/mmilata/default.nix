# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  jicofo = pkgs.callPackage ./pkgs/jicofo { };
  jitsi-meet = pkgs.callPackage ./pkgs/jitsi-meet { };
  jitsi-videobridge = pkgs.callPackage ./pkgs/jitsi-videobridge { };

  fetchMavenDeps = pkgs.callPackage ./lib/fetch-maven-deps.nix { };

  jicofo-git = pkgs.callPackage ./pkgs/jicofo-git { inherit fetchMavenDeps; };
  jitsi-videobridge-git = pkgs.callPackage ./pkgs/jitsi-videobridge-git { inherit fetchMavenDeps; };

  prometheus-lnd-exporter = pkgs.callPackage ./pkgs/prometheus-lnd-exporter { };
  lndmanage = pkgs.callPackage ./pkgs/lndmanage { };
  rtl = pkgs.callPackage ./pkgs/rtl { };
}

