{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "7ab9f25c4a8c313d99a1e188af77cf02d60a9c3c";
  sha256 = "sha256-aN9C6u2VHQoU1EZKQV3uoUpS2Lxuj+JhXtGJtUvEyRw=";
  version = "0-unstable-2025-03-11";
  branch = "staging-next";
}
