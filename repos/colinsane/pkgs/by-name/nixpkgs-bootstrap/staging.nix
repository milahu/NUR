{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d52d16c1d5fb254d76257dfb98b187d3730de5c7";
  sha256 = "sha256-DAUHpYWte4hXUI3WC3znTToDdweqHyZpiDXNLU2PgxA=";
  version = "unstable-2025-12-24";
  branch = "staging";
}
