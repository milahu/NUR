{
  description = "My personal NUR repository";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    flake-linter = {
      url = "gitlab:kira-bruneau/flake-linter";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-fast-build.url = "github:Mic92/nix-fast-build";
  };

  outputs = { self, flake-utils, flake-linter, nixpkgs, nix-fast-build }:
    {
      overlays = import ./overlays;
      nixosModules = import ./nixos/modules;
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          config = {
            allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (nixpkgs.lib.getName pkg)).name [
              "anytype"
              "anytype-heart"
              "anytype-nmh"
              "clonehero"
              "virtualparadise"
            ];

            permittedInsecurePackages = [
              "electron-24.8.6"
            ];
          };

          inherit system;
        };

        flake-linter-lib = flake-linter.lib.${system};

        paths = flake-linter-lib.partitionToAttrs
          flake-linter-lib.commonPaths
          (builtins.filter
            (path:
              (builtins.all
                (ignore: !(nixpkgs.lib.hasSuffix ignore path))
                [
                  "gemset.nix"
                ]))
            (flake-linter-lib.walkFlake ./.));

        linter = flake-linter-lib.makeFlakeLinter {
          root = ./.;

          settings = {
            markdownlint = {
              paths = paths.markdown;
              settings = {
                default = true;
                MD013 = false;
              };
            };

            nixpkgs-fmt.paths = paths.nix;

            prettier.paths = paths.markdown;
          };
        };

        nurPkgs = import ./pkgs (pkgs // nurPkgs) pkgs;

        flatNurPkgs = flake-utils.lib.flattenTree nurPkgs;
      in
      rec {
        packages = flake-utils.lib.filterPackages system flatNurPkgs;

        checks = packages;

        apps = {
          sync = {
            type = "app";
            program = nixpkgs.lib.getExe (nurPkgs.callPackage ./maintainers/scripts/sync.nix {
              nix-fast-build = nix-fast-build.packages.${system}.default;
              inherit nixpkgs;
            });
          };

          update = {
            type = "app";
            program = toString (nurPkgs.callPackage ./maintainers/scripts/update.nix {
              packages = builtins.concatMap
                (name:
                  let
                    package = flatNurPkgs.${name};
                    attrPath = builtins.replaceStrings [ "/" ] [ "." ] name;
                  in
                  if package ? updateScript
                  then [{ inherit package attrPath; }]
                  else [ ]
                )
                (builtins.attrNames flatNurPkgs);

              inherit nixpkgs;
            });
          };

          inherit (linter) fix;
        };
      }
    );
}
