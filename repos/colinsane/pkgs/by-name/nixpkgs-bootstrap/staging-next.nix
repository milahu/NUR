{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "63764ecdf7119793402d2b254b9d4683a7ca4f9f";
  sha256 = "sha256-Z1FXlaWWA5Vq6lwiW7bwJFgPLX5vBC0eyiiGLhIAlhY=";
  version = "unstable-2025-12-17";
  branch = "staging-next";
}
