# Composes the packages collection.

# based on xeals/pkgs/top-level/default.nix

{
  # The system packages will be build and used on.
  localSystem
  # Nixpkgs
, pkgs
  # TODO(milahu): why is lib exposed as a parameter?
  # Nixpkgs lib
, lib ? pkgs.lib
}:

let

  allPackages = import ./stage.nix {
    inherit lib pkgs;
  };

  /*
  # filter by drv.meta.platforms
  available = lib.filterAttrs
    (_: drv: builtins.elem localSystem (drv.meta.platforms or [ ]));
  */

  # dont filter to eval faster
  available = x: x;

in

available allPackages
