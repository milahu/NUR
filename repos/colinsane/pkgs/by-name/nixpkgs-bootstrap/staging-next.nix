{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "9aca1a51399797ecc5ae793916927b3f29cf0dc7";
  sha256 = "sha256-X27t6EhliWC2dfQ8kfJXY/IZKaDDtc+hWcmloVNSVO4=";
  version = "unstable-2026-02-04";
  branch = "staging-next";
}
