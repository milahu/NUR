{
  buildMozillaXpiAddon,
  fetchurl,
  lib,
  stdenv,
}:

let

  generatedPackages = import ./generated-thunderbird-addons.nix {
    inherit
      buildMozillaXpiAddon
      fetchurl
      lib
      stdenv
      ;
  };

in
generatedPackages
