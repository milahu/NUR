{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e8e57d2c31220d1aa920b6dab4ae197805b3c295";
  sha256 = "sha256-KHKJju8UQ60IlwsVRvyqVKBpMWWiOMq1la4KceQfqzY=";
  version = "0-unstable-2025-03-09";
  branch = "staging-next";
}
