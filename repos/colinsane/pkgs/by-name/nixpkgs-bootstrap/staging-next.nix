{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "b84a16327e855f7bcaf32b30c5dff133a2d53abc";
  sha256 = "sha256-rUk0I9EWQe4cFFm0zw3RBB6rKxdBwcTRisP4jNtfeD4=";
  version = "0-unstable-2024-12-03";
  branch = "staging-next";
}
