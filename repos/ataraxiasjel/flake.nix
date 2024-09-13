{
  description = "AtaraxiaSjel's NUR repository";
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      perSystem =
        {
          pkgs,
          lib,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          legacyPackages = import ./pkgs/default.nix { inherit pkgs; };
          # Currently does not populate derivations from recurseIntoAttrs
          # packages = lib.filterAttrs (_: v: lib.isDerivation v) legacyPackages;
          # Get all packages from ci.nix
          packages = (import ./ci.nix { inherit pkgs; }).buildPkgs;
          checks = (import ./ci.nix { inherit pkgs; }).cachePkgs;
        };
      flake = {
        lib = import ./lib;
        overlays = import ./overlays;
        nixosModules = import ./modules;
      };
    };

  nixConfig = {
    extra-substituters = [ "https://ataraxiadev-foss.cachix.org" ];
    extra-trusted-public-keys = [
      "ataraxiadev-foss.cachix.org-1:ws/jmPRUF5R8TkirnV1b525lP9F/uTBsz2KraV61058="
    ];
  };
}
