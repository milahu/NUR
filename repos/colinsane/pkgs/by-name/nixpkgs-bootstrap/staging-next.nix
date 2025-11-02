{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e0fba51a966966ccc4e30c69a83bd186b7f0b5e0";
  sha256 = "sha256-3nFQ5yzQMVCu9Iv9JZoV93vD0cILsP/JSZZm889t0ig=";
  version = "unstable-2025-11-01";
  branch = "staging-next";
}
