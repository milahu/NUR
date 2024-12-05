{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "116c78e039ad14ce9f16619e9984fa6e728e9319";
  sha256 = "sha256-RyGyqku9z3E1hT5VBkT0O3k2wBq/YFLD/NZU1NWn46o=";
  version = "0-unstable-2024-12-04";
  branch = "staging";
}
