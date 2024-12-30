{
  description = "epitaphpkgs Nix package repository";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = { nixpkgs, self, ... }:
    let inherit (nixpkgs.lib) genAttrs systems;

        forAllSystems = f: genAttrs systems.flakeExposed (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
    in {
      packages = forAllSystems ({ pkgs, ... }:
        import ./default.nix { inherit pkgs; });

      legacyPackages = self.packages;
    };
}
