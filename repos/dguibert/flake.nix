{
  description = "A flake for building my NUR packages";

  inputs.emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  inputs.nixpkgs.url = "github:dguibert/nixpkgs/pu";

  inputs.nix.url = "github:dguibert/nix/pu"; # boehmgc 8.2.4
  inputs.nix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-custom-store.url = "github:dguibert/nix-custom-store";
  inputs.nix-custom-store.inputs.nix.follows = "nix";

  # for overlays/updated-from-flake.nix
  inputs.dwl-src.flake = false;
  inputs.dwl-src.url = "github:dguibert/dwl/pu";
  inputs.dwm-src.flake = false;
  inputs.dwm-src.url = "github:dguibert/dwm/pu";
  inputs.emacs-src.flake = false;
  inputs.emacs-src.url = "github:emacs-mirror/emacs/emacs-29";
  inputs.mako-src.flake = false;
  inputs.mako-src.url = "github:emersion/mako/master";
  inputs.st-src.flake = false;
  inputs.st-src.url = "github:dguibert/st/pu";

  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    nix,
    ...
  }: let
    inherit (self) outputs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        lib = nixpkgs.lib;
        overlays = import ./overlays {
          inherit inputs;
          lib = inputs.nixpkgs.lib;
        };

        templates = {
          env_flake = {
            path = ./templates/env_flake;
            description = "A bery basic env for my project";
          };
          terraform = {
            path = ./templates/terraform;
            description = "A template to use terranix/terraform";
          };
        };
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [
        #./home/profiles
        #./hosts
        ./modules/all-modules.nix
        #./lib
        ./apps
        ./checks
        ./shells
      ];

      #perSystem = {config, self', inputs', pkgs, system, ...}: {
      #};
    };
}
