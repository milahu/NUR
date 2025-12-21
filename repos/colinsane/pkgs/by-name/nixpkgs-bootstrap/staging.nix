{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "131ec92bb06e9b4a2e0b528e2cba75e25687a62b";
  sha256 = "sha256-/sRuSPvYGHrPu1d55YUHRpn+GRtK7i9vIebV84Le1UQ=";
  version = "unstable-2025-12-20";
  branch = "staging";
}
