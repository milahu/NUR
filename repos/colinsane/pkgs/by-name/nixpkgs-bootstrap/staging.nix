{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "f0e73b01a56f6eb6353dbaecb45bf123d7c3628c";
  sha256 = "sha256-ZHXKsvryVQKF7t/fpiHn8SDu+P2TVsgVr+Id7hC14SQ=";
  version = "0-unstable-2024-12-05";
  branch = "staging";
}
