{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "9af6b8f86e5dec559ff786dab8fa8e3b1abd3ea9";
  sha256 = "sha256-V/ownOrA8Pk1KzkYgYGOjWyrgr4PgN3s9UwQ7rKwPHM=";
  version = "unstable-2025-11-30";
  branch = "staging-next";
}
