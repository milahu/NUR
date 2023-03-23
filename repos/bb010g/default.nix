{ pkgs ? import <nixpkgs> { }, enablePkgsCompat ? false }:

let recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };
self = {
  lib = self.lib'.standalone pkgs.lib;
  lib' = import ./lib;
  libExtension = self.lib'.extension;
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # Nixpkgs overlays
  pkgs = recurseIntoAttrs
    (import ./pkgs { inherit pkgs; inherit (self) libExtension; });
}; in if enablePkgsCompat then self.pkgs // self else self
