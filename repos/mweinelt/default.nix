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

  hassLovelaceModules = pkgs.recurseIntoAttrs {
    apexcharts-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/apexcharts-card {};
    atomic-calendar-revive = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/atomic-calendar-revive {};
    button-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/button-card {};
    mini-graph-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/mini-graph-card {};
    mini-media-player = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/mini-media-player {};
    multiple-entity-row = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/multiple-entity-row {};
    mushroom = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/mushroom {};
    rgb-light-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/rgb-light-card {};
    rmv-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/rmv-card {};
    sun-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/sun-card {};
    slider-button-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/slider-button-card {};
    swipe-navigation = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/swipe-navigation {};
    template-entity-row = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/template-entity-row {};
    vacuum-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/vacuum-card {};
    valetudo-map-card = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/valetudo-map-card {};
    weather-card-chart = pkgs.callPackage ./pkgs/home-assistant/lovelaceModules/weather-card-chart {};
  };

  hassThemes = pkgs.recurseIntoAttrs {
    clear = pkgs.callPackage ./pkgs/home-assistant/themes/clear {};
    clear-dark = pkgs.callPackage ./pkgs/home-assistant/themes/clear-dark {};
  };

  oscam = pkgs.callPackage ./pkgs/servers/tv/oscam { };

  cmangos_classic = pkgs.callPackage ./pkgs/servers/games/cmangos/classic.nix { };
  cmangos_tbc = pkgs.callPackage ./pkgs/servers/games/cmangos/tbc.nix { };
  cmangos_wotlk = pkgs.callPackage ./pkgs/servers/games/cmangos/wotlk.nix { };


  trinitycore_335 = pkgs.callPackage ./pkgs/servers/games/trinitycore/335.nix { };
  trinitycore_434 = pkgs.callPackage ./pkgs/servers/games/trinitycore/434.nix { };
  trinitycore_927 = pkgs.callPackage ./pkgs/servers/games/trinitycore/927.nix { };
  trinitycore_1005 = pkgs.callPackage ./pkgs/servers/games/trinitycore/1005.nix { };

  vmangos = pkgs.callPackage ./pkgs/servers/games/vmangos {};
  vmangos-worlddb = pkgs.callPackage ./pkgs/servers/games/vmangos/worlddb.nix {};
}
