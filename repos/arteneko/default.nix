{
  pkgs ? import <nixpkgs> {}
}:
{
  # my packages
  cap = pkgs.callPackage ./pkgs/cap.nix {};
  svg = pkgs.callPackage ./pkgs/svg.nix {};
  paste = pkgs.callPackage ./pkgs/paste.nix {};

  # overrides
  vivaldi = pkgs.callPackage ./overrides/vivaldi.nix {};
  chromium = pkgs.callPackage ./overrides/chromium.nix {};

  # my nixos and home-manager options (TBD, e.g. for services)
  modules = import ./modules;
}
