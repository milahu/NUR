{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e9d374194e7c2455c970b2084c95a77adda657c8";
  sha256 = "sha256-DbSvuGNP4i3g8HqydMZAYkK7ucvY6vuT5331OwAszbk=";
  version = "unstable-2025-11-22";
  branch = "staging-next";
}
