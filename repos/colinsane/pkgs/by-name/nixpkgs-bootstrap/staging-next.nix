{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "fc7fa5f568c170348fa21308f135fa9cd0807725";
  sha256 = "sha256-9DP8lq3aHYmSCVgDNKGiNoEHlwkz+bb+5K+KYDFF1Ng=";
  version = "0-unstable-2025-02-17";
  branch = "staging-next";
}
