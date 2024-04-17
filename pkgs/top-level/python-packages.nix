# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

#self: super: with self; { # nixpkgs

{ pkgs, callPackage }: {

  # nix-build . -A python3Packages._setuptools
  # nix-build . -A python3.pkgs._setuptools
  #_setuptools = callPackage ../development/python-modules/setuptools { };

  /*
  _zstd = callPackage ../development/python-modules/zstd {
    inherit (pkgs) zstd;
  };
  */

}
