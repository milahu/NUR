# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # applications/office
  foliate = pkgs.callPackage ./pkgs/applications/office/foliate { };
  onlyoffice-desktopeditors = pkgs.callPackage ./pkgs/applications/office/onlyoffice-desktopeditors { };

  # services/security
  # inherit (pkgs.callPackage ./pkgs/services/security/opensnitch {}) opensnitchd opensnitch-ui;
  # FIXME

  # tools/security
  # appvm = pkgs.callPackage ./pkgs/tools/security/appvm { }; # FIXME

  # node-packages
  #inherit (pkgs.callPackages ./pkgs/node-packages {}) hyperpotamus;

  #xerox6000-6010 = pkgs.callPackage ./pkgs/xerox6000-6010 { };
  libtransmission = pkgs.callPackage ./pkgs/libtransmission { };
  #fragments = pkgs.callPackage ./pkgs/fragments { };
  passwordsafe = pkgs.callPackage ./pkgs/passwordsafe { };
  # popcorntime = pkgs.callPackage ./pkgs/popcorntime { }; # FIXME
  iwd-autocaptiveauth = pkgs.callPackage ./pkgs/iwd-autocaptiveauth { }; # FIXME upstream hyperpotamus dependency
  librewolf-bin = pkgs.callPackage ./pkgs/librewolf-bin { };
  ocenaudio = pkgs.callPackage ./pkgs/ocenaudio { };
  snipping_tool = pkgs.callPackage ./pkgs/snipping_tool { };
  smloadr = pkgs.callPackage ./pkgs/smloadr { };

}

