{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
        flake-compat.follows = "";
      };
    };

    # Indirect
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
      git-hooks,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem =
        {
          lib,
          config,
          pkgs,
          system,
          ...
        }:
        {
          legacyPackages = pkgs.callPackage ./. { };
          packages = lib.filterAttrs (_: lib.isDerivation) config.legacyPackages;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              jq
              just
              nix-inspect
              nix-output-monitor
              nix-tree
            ];

            shellHook = ''
              ${config.checks.pre-commit-check.shellHook}
              just --list
            '';
          };

          apps.update = {
            type = "app";
            program = lib.getExe (
              pkgs.writeShellApplication {
                name = "update";
                text = ''
                  nix-shell --show-trace "${nixpkgs.outPath}/maintainers/scripts/update.nix" \
                    --arg include-overlays "[(import ./overlay.nix)]" \
                    --arg predicate '(
                      let prefix = builtins.toPath ./pkgs; prefixLen = builtins.stringLength prefix;
                      in (_: p: p.meta?position && (builtins.substring 0 prefixLen p.meta.position) == prefix)
                    )'
                '';
              }
            );
          };

          checks = {
            pre-commit-check = git-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                # Nix
                nixfmt = {
                  enable = true;
                  package = config.formatter;
                };
                deadnix.enable = true;
                statix.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };

  nixConfig = {
    extra-substituters = [ "https://federicoschonborn.cachix.org" ];
    extra-trusted-public-keys = [
      "federicoschonborn.cachix.org-1:tqctt7S1zZuwKcakzMxeATNq+dhmh2v6cq+oBf4hgIU="
    ];
  };
}
