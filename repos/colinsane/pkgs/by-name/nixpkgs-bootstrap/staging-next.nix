{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "0c0d9a591ca1783b8a3d6c5f6945c6e42e10fdc0";
  sha256 = "sha256-X4s/1A90IhckXpPVT9/t+PxlpsDDV3n6XZYDudgzAlI=";
  version = "unstable-2025-11-06";
  branch = "staging-next";
}
