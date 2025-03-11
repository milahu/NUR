{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "d435aedd7fa4783b0827e7cc8ca14b4eff759c7e";
  sha256 = "sha256-NVOVTIxuPS/QRD8T5CFqOhfPqVJKsx7tWufZxW17li8=";
  version = "0-unstable-2025-03-09";
  branch = "staging";
}
