{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "8e9c0cbfc4a11ebe6fb61f4163bdddc231b0f208";
  sha256 = "sha256-MuoOTvNZA8xtIpSiVmHTjRTPPHZ+NDRwwPCxwa7ftS8=";
  version = "unstable-2025-12-01";
  branch = "staging-next";
}
