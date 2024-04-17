# Composes a single bootstrapping of the package collection. The result is a set
# of all the packages for some particular platform.

# based on
# xeals/pkgs/top-level/stage.nix
# nixpkgs/pkgs/top-level/stage.nix

{ lib
, pkgs
}:

let

  # An overlay to auto-call packages in .../by-name.
  autoCalledPackages =
    import ./by-name-overlay.nix { inherit pkgs lib; } ../by-name;

  allPackages = _self: _super:
    import ./all-packages.nix { inherit pkgs; };

  #aliases = self: super: lib.optionalAttrs config.allowAliases (import ./aliases.nix lib self super);

  # The complete chain of package set builders, applied from top to bottom.
  toFix = (lib.flip lib.composeManyExtensions) (_self: { }) [
    autoCalledPackages
    allPackages
    #aliases
  ];

in

# Return the complete set of packages.
lib.fix toFix
