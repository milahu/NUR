{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "b1cbcefc921586c65ca7b882cdd54775e5c80fa3";
  sha256 = "sha256-ni8ASRbpA3iMBitkiAH21NKH7icKg87V6XkqgnAzKac=";
  version = "0-unstable-2025-03-05";
  branch = "staging";
}
