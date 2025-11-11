{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "1a02cfff40a76fa50e9643a30e4c71acfaf53fdd";
  sha256 = "sha256-zy9l/bTiwmX2whoAg1Sb7qD6d27pgboJmh3iscWoO84=";
  version = "unstable-2025-11-10";
  branch = "staging";
}
