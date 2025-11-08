{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "6d1529ce8ca5cd2a9a3be42cc274720a7d041b0f";
  sha256 = "sha256-wlrtztB37he5jpq2LAMywzS0e1cfEuD9Ibo23kLIAM8=";
  version = "unstable-2025-11-07";
  branch = "staging-next";
}
