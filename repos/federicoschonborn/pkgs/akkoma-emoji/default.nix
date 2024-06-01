{ lib, pkgs }:

{
  volpeon = lib.makeScope pkgs.newScope (
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./volpeon;
    }
  );

  eppa = lib.makeScope pkgs.newScope (
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./eppa;
    }
  );

  renere = lib.makeScope pkgs.newScope (
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./renere;
    }
  );
}
