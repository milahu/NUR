{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e9b8da1eccbecfd2686109acd67693dc9de548a4";
  sha256 = "sha256-IHMHV7+kcr8Yw0Z3FrGlCNM898ykoliPltCiNdNrihM=";
  version = "unstable-2025-11-03";
  branch = "staging";
}
