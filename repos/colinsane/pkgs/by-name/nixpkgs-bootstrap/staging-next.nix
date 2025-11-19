{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "17e22a1242fa6c903bea6aa13e6b6fd7323a6639";
  sha256 = "sha256-MpNV3Lr5W03RwpXtgBV5AVd7cVeMZAB6ESETu/ICk40=";
  version = "unstable-2025-11-18";
  branch = "staging-next";
}
