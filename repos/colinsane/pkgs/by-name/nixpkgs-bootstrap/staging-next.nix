{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "c754645394cbe8ffbe93b5761e05a0b6edbb155f";
  sha256 = "sha256-hJonkzuYXJ9cDqmKnuuBXwtZJKlw7YaqiBDsdQOFlFA=";
  version = "unstable-2025-11-09";
  branch = "staging-next";
}
