{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "f55fd6e3f7c5dd82d051cf3d9bbdafd35020e5ad";
  sha256 = "sha256-s0ra5X5KQM9z2GOpX+je8flFqtGeUrL2Z8cjIrHgqdk=";
  version = "unstable-2025-12-18";
  branch = "staging";
}
