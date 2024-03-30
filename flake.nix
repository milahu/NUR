/*
  NOTE this flake.nix is only a compatibility layer
  to make default.nix work with flakes

  if you use this flake.nix to add extra inputs
  then these inputs are not reachable from default.nix
  so your repo will fail to eval in NUR/ci/nur/update.py

  to make extra inputs reachable for default.nix
  you can add them as gitmodules:

    git submodule add https://... pkgs/somepkg

  to enable gitmodules, add this to repos.json:

    { "submodules": true }
*/

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
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
      });
      packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});
    };
}
