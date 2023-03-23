# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  # Libraries
  girara = pkgs.callPackage ./pkgs/girara { gtk = pkgs.gtk3; };
  libutf = pkgs.callPackage ./pkgs/libutf { };

  # Programs
  cabytcini = pkgs.callPackage ./pkgs/cabytcini { };
  comma = pkgs.callPackage ./pkgs/comma { };
  deno = pkgs.callPackage ./pkgs/deno { };
  discord = pkgs.callPackage ./pkgs/discord { };
  gopls = pkgs.callPackage ./pkgs/gopls { };
  gruvbox-css = pkgs.callPackage ./pkgs/gruvbox-css { };
  hewwo = pkgs.callPackage ./pkgs/hewwo { };
  ii = pkgs.callPackage ./pkgs/ii { };
  ix = pkgs.callPackage ./pkgs/ix { };
  johaus = pkgs.callPackage ./pkgs/johaus { };
  jvozba = pkgs.callPackage ./pkgs/jvozba { };
  lchat = pkgs.callPackage ./pkgs/lchat { inherit libutf; };
  luakit = pkgs.callPackage ./pkgs/luakit {
    inherit (pkgs.luajitPackages) luafilesystem;
  };
  minica = pkgs.callPackage ./pkgs/minica { };
  nix-simple-deploy = pkgs.callPackage ./pkgs/nix-simple-deploy { };
  orca = pkgs.callPackage ./pkgs/orca { };
  pridecat = pkgs.callPackage ./pkgs/pridecat { };
  quickserv = pkgs.callPackage ./pkgs/quickserv { };
  sctd = pkgs.callPackage ./pkgs/sctd { };
  steno-lookup = pkgs.callPackage ./pkgs/steno-lookup { };
  sw = pkgs.callPackage ./pkgs/sw { };
  zathura = pkgs.callPackage ./pkgs/zathura { inherit girara; };

  # lua libraries
  lua = {
    dnd_dice = pkgs.callPackage ./pkgs/lua/dnd_dice { };
    ln = pkgs.callPackage ./pkgs/lua/ln {
      inherit (pkgs.lua53Packages) buildLuarocksPackage dkjson;
    };
  };

  # binary programs
  microsoft-edge-dev = pkgs.callPackage ./pkgs/microsoft-edge-dev { };

  # "fun" programs
  sm64pc = pkgs.callPackage ./pkgs/sm64pc { };
}

