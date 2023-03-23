{ config, callPackage, lib }:

let
  inherit (callPackage ./fish-utils.nix {}) buildFishPlugin;

  plugins = callPackage ./generated.nix {
    inherit buildFishPlugin overrides;
  };

  # TL;DR
  # * Add your plugin to ./fish-plugin-names
  # * sort -udf ./fish-plugin-names > sorted && mv sorted fish-plugin-names
  # * run ./update.py
  #
  # If additional modifications to the build process are required,
  # add to ./overrides.nix.
  overrides = callPackage ./overrides.nix {
    inherit buildFishPlugin;
  };

  aliases = lib.optionalAttrs (config.allowAliases or true) (import ./aliases.nix lib plugins);
in { recurseForDerivations = true; } // plugins // aliases
