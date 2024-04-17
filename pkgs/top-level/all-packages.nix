# The top-level package collection

# { lib, noSysDirs, config, overlays }: res: pkgs: super: # nixpkgs
{ pkgs }: # xeals

with pkgs; # nixpkgs

#{ # nixpkgs
rec { # xeals

  #_type = "pkgs"; # nixpkgs



  # packages with the old path format

  # with the new by-name path format
  # there is no more need to add packages here
  # simply add pkgs/by-name/so/some-package/package.nix
  # and run: nix-build . -A some-package

  #example-package = callPackage ../example-package { };

  #some-qt5-package = pkgs.libsForQt5.callPackage ../some-qt5-package { };



  # python

  /*
  # based on nagy/default.nix
  python3Packages = pkgs.recurseIntoAttrs
    (lib.makeScope pkgs.python3Packages.newScope
      (self: import ./python-packages.nix {
        inherit (self) callPackage; # pkgs.python3.callPackage
        inherit pkgs;
      }));

  # alias: python3.pkgs -> python3Packages
  # based on milahu/default.nix
  python3 = pkgs.recurseIntoAttrs (((pkgs.python3 // {
    pkgs = python3Packages;
  })));
  */



  # nodejs

  # based on
  # nixpkgs/pkgs/development/web/nodejs/nodejs.nix
  # nixpkgs/pkgs/development/node-packages/node-packages.json

  /*
  nodePackages = {
    # use node2nix from nixpkgs
    # node2nix has many dependencies that would bloat node-packages.json
    inherit (pkgs) node2nix;
  } // (callPackage ../development/node-packages/default.nix {
    inherit (pkgs) nodejs;
  });

  # alias: nodejs.pkgs -> nodePackages
  nodejs = pkgs.recurseIntoAttrs (((pkgs.nodejs // {
    pkgs = nodePackages;
  })));
  */



  # lisp

  /*
  lispPackages = pkgs.recurseIntoAttrs
    (lib.makeScope pkgs.newScope
      (self: import ./lisp-packages.nix {
        inherit (self) callPackage;
        inherit pkgs;
      }));
  */



  # qemu

  # based on nagy/default.nix

  /*
  qemuImages = pkgs.recurseIntoAttrs
    (lib.makeScope pkgs.newScope
      (self: import ./qemu-images.nix {
        inherit (self) callPackage;
        inherit pkgs;
      }));
  */

}
