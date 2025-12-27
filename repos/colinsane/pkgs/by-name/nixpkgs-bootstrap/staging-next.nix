{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "872365894d719618afcd8fdf8805af9d06858681";
  sha256 = "sha256-0pNl4L1FeztYUBNJ+RYKAuYGKuD8NxhVSnaA/cXm7Xc=";
  version = "unstable-2025-12-24";
  branch = "staging-next";
}
