{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "9629ba62cc9cfe62f819d692932ffcdbd911bf77";
  sha256 = "sha256-t9nY4j4MZvNqqpaRLnTIwxDrAsKaOo/1iNJpeIDgqRA=";
  version = "unstable-2025-11-03";
  branch = "staging-next";
}
