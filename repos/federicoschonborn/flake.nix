{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

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
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      git-hooks,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ git-hooks.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "i686-linux"
        "armv6l-linux"
        "armv7l-linux"

        "x86_64-darwin"
        "aarch64-darwin"
      ];

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
            config = {
              allowBroken = true;
              allowUnfreePredicate =
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
          };

          legacyPackages = import ./. { inherit pkgs; };
          packages = lib.filterAttrs (_: lib.isDerivation) config.legacyPackages;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              jq
              nix-inspect
              nix-tree
              nushell
              (writeScriptBin "just" ''
                #!${lib.getExe nushell}
                ${builtins.readFile ./just.nu}
              '')
            ];

            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };

          apps =
            builtins.mapAttrs
              (_: value: {
                type = "app";
                program = lib.getExe value;
              })
              {
                generate-program-list = pkgs.writeShellApplication {
                  name = "generate-program-list";
                  excludeShellChecks = [ "SC2129" ];
                  text =
                    ''
                      echo "{" > meta/program-list.json
                    ''
                    + (builtins.concatStringsSep "\n" (
                      builtins.attrValues (
                        builtins.mapAttrs (name: value: ''
                          if test -d ${value}/bin; then
                            echo '  "${name}": ' >> meta/program-list.json
                            ${lib.getExe pkgs.nushell} -c 'ls --short-names --long ${value}/bin | where type == "file" and mode =~ "x" | get name | sort | to json' >> meta/program-list.json
                            echo ',' >> meta/program-list.json
                          fi
                        '') config.packages
                      )
                    ))
                    + ''
                      echo "}" >> meta/program-list.json
                      ${lib.getExe pkgs.nodePackages.prettier} --write meta/program-list.json
                    '';
                };

                generate-readme =
                  let
                    packageList = pkgs.writeText "package-list.md" (
                      builtins.concatStringsSep "\n" (
                        builtins.attrValues (
                          builtins.mapAttrs (
                            name: value:
                            let
                              programList = lib.importJSON meta/program-list.json;
                              programs = programList.${name} or [ ];

                              description = value.meta.description or "";
                              longDescription = value.meta.longDescription or "";
                              outputs = value.outputs or [ ];
                              homepage = value.meta.homepage or "";
                              changelog = value.meta.changelog or "";
                              position = value.meta.position or "";
                              licenses = lib.toList (value.meta.license or [ ]);
                              maintainers = value.meta.maintainers or [ ];
                              platforms = value.meta.platforms or [ ];
                              mainProgram = value.meta.mainProgram or "";
                              broken = value.meta.broken or false;
                              unfree = value.meta.unfree or false;

                              brokenSection =
                                if broken then
                                  "💥 This package has been marked as **broken**! You may need to set `allowBroken = true`.\n\n"
                                else
                                  "";

                              unfreeSection =
                                if unfree then
                                  "🔒 This package has been marked as **unfree**! You may need to set `allowUnfree = true`.\n\n"
                                else
                                  "";

                              descriptionSection = if longDescription != "" then longDescription else "${description}.";

                              outputsSection =
                                let
                                  formatOutput = x: if x == value.outputName then "**`${x}`**" else "`${x}`";
                                in
                                lib.optionalString (outputs != [ ]) (
                                  "- Outputs: " + (builtins.concatStringsSep ", " (builtins.map formatOutput outputs)) + "\n"
                                );

                              homepageSection = lib.optionalString (homepage != "") "- [🌐 Homepage](${homepage})\n";

                              changelogSection = lib.optionalString (changelog != "") "- [📰 Changelog](${changelog})\n";

                              sourceSection =
                                let
                                  formatPosition =
                                    x:
                                    let
                                      parts = builtins.match "/nix/store/.{32}-source/(.+):([[:digit:]]+)" x;
                                      path = builtins.elemAt parts 0;
                                      line = builtins.elemAt parts 1;
                                    in
                                    "./${path}#L${line}";
                                in
                                lib.optionalString (position != "") "- [📦 Source](${formatPosition position})\n";

                              licenseSection =
                                let
                                  formatLicense = x: "[`${x.spdxId}`](${x.url} '${x.fullName}')";
                                in
                                lib.optionalString (licenses != null) (
                                  "- License${if builtins.length licenses > 1 then "s" else ""}: "
                                  + (builtins.concatStringsSep ", " (builtins.map formatLicense licenses))
                                  + "\n"
                                );

                              programsSection =
                                let
                                  formatProgram = x: if x == mainProgram then "**`${x}`**" else "`${x}`";
                                in
                                lib.optionalString (programs != [ ]) (
                                  "- Programs provided: "
                                  + (builtins.concatStringsSep ", " (builtins.map formatProgram programs))
                                  + "\n"
                                );

                              maintainersSection =
                                let
                                  formatMaintainer =
                                    x:
                                    let
                                      name = if x ? github then "[${x.name}](https://github.com/${x.github})" else x.name;
                                      email = if x ? email then " <[`${x.email}`](mailto:${x.email})>" else "";
                                    in
                                    "  - ${name}${email}\n";
                                  allMaintainersLink =
                                    if builtins.any (x: x ? email) maintainers then
                                      "  - [✉️ Mail to all maintainers](mailto:"
                                      + (builtins.concatStringsSep "," (builtins.map (x: x.email or null) maintainers))
                                      + ")"
                                    else
                                      "";
                                in
                                lib.optionalString (maintainers != [ ]) (
                                  "- Maintainers:\n"
                                  + (builtins.concatStringsSep "" (builtins.map formatMaintainer maintainers))
                                  + allMaintainersLink
                                  + "\n"
                                );

                              platformsSection =
                                let
                                  formatPlatform = x: "  - `${x}`\n";
                                in
                                lib.optionalString (platforms != [ ]) (
                                  "- Platforms:\n" + (builtins.concatStringsSep "" (builtins.map formatPlatform platforms)) + "\n"
                                );
                            in
                            ''
                              ### `${name}`

                            ''
                            + brokenSection
                            + unfreeSection
                            + descriptionSection
                            + ''

                              - Name: `${value.pname}`
                              - Version: ${value.version}
                            ''
                            + outputsSection
                            + homepageSection
                            + changelogSection
                            + sourceSection
                            + licenseSection
                            + ''

                              <!-- markdownlint-disable-next-line no-inline-html -->
                              <details>
                                <!-- markdownlint-disable-next-line no-inline-html -->
                                <summary>
                                  Package details
                                </summary>

                            ''
                            + programsSection
                            + maintainersSection
                            + platformsSection
                            + ''

                              </details>
                            ''
                          ) config.packages
                        )
                      )
                    );
                  in
                  pkgs.writeShellApplication {
                    name = "generate-readme";
                    text = ''
                      cat ${meta/README.tmpl.md} ${packageList} > README.md
                      ${lib.getExe pkgs.nodePackages.prettier} --write README.md
                    '';
                  };

                update = pkgs.writeShellApplication {
                  name = "update";
                  text = ''
                    nix-shell --show-trace "${nixpkgs.outPath}/maintainers/scripts/update.nix" \
                      --arg commit 'true' \
                      --arg include-overlays "[(import ./overlay.nix)]" \
                      --arg keep-going 'true' \
                      --arg predicate '(
                        let prefix = builtins.toPath ./pkgs; prefixLen = builtins.stringLength prefix;
                        in (_: p: p.meta?position && (builtins.substring 0 prefixLen p.meta.position) == prefix)
                      )'
                  '';
                };
              };

          pre-commit = {
            check.enable = true;
            settings.hooks = {
              # Nix
              nixfmt = {
                enable = true;
                package = config.formatter;
              };
              deadnix.enable = true;
              statix.enable = true;
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
