{ lib, pkgs }:

{
  volpeon = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./volpeon;
  };

  eppa = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./eppa;
  };

  renere = lib.packagesFromDirectoryRecursive {
    inherit (pkgs) callPackage;
    directory = ./renere;
  };
}
