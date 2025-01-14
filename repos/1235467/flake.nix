{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    nixpkgs-yuzu = {
      url = "github:NixOS/nixpkgs/71e91c409d1e654808b2621f28a327acfdad8dc2";
    };
  };
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-yuzu,
      dream2nix,
      ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      system = "x86_64-linux";
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    rec {
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-yuzu = import nixpkgs-yuzu {
            inherit system;
            config.allowUnfree = true;
          };
        }
      );
      packages = forAllSystems (
        system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
      );

    };
}
