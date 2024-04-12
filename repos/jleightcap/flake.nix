{
  description = "My personal NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      legacyPackages = forAllSystems (system:
        import ./default.nix { pkgs = import nixpkgs { inherit system; }; });
      packages = forAllSystems (system:
        nixpkgs.lib.filterAttrs (_: nixpkgs.lib.isDerivation)
        self.legacyPackages.${system});
    };
}
