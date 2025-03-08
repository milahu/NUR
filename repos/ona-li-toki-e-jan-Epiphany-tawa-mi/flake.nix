# MIT License
#
# Copyright (c) 2024-2025 ona-li-toki-e-jan-Epiphany-tawa-mi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

{
  description = "epitaphpkgs Nix package repository";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, self, ... }:
    let
      inherit (nixpkgs.lib) genAttrs systems;

      forAllSystems = f:
        genAttrs systems.flakeExposed
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      packages =
        forAllSystems ({ pkgs, ... }: import ./default.nix { inherit pkgs; });
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-classic);

      legacyPackages = self.packages;

      overlays.default = final: prev: {
        epitaphpkgs = self.packages.${prev.system};
      };

      nixosModules.default = { nixpkgs.overlays = [ self.overlays.default ]; };
    };
}
