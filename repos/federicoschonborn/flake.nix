{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    systems = {
      url = "path:./systems.nix";
      flake = false;
    };

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
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate =
              p:
              builtins.elem (lib.getName p) [
                "eevee-neopossum"
                "eppa-neobun"
                "eppa-neocube"
                "fotoente-neodino"
                "fotoente-neohaj"
                "fotoente-neomilk"
                "fotoente-neotrain"
                "renere-spinny-blobcats"
                "renere-spinny-blobfoxes"
                "renere-spinny-blobs"
                "olivvybee-blobbee"
                "olivvybee-fox"
                "olivvybee-neobread"
                "olivvybee-neocat"
                "olivvybee-neodlr"
                "olivvybee-neofox"
                "olivvybee-neossb"
                "volpeon-drgn"
                "volpeon-floof"
                "volpeon-gphn"
                "volpeon-neocat"
                "volpeon-neofox"
                "volpeon-vlpn"
              ];
          };

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
                    --arg keep-going 'true' \
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
