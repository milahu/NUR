{
  description = "My personal NUR repository";
  inputs = {
    pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay/ed8aa5b64f7d36d9338eb1d0a3bb60cf52069a72"; # 24-11-23
      inputs.nixpkgs.follows = "pkgs";
    };
  };
  outputs = inputs@{ ... }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: inputs.pkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (system: import ./default.nix {
        pkgs = import inputs.pkgs {
          overlays = [ (import inputs.rust-overlay) ];
          inherit system;
        };
      });
    };
}
