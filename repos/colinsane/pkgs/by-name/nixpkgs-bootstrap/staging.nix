{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "4ff3efbb260d45b7692e4773b829c4e1cbd8b168";
  sha256 = "sha256-NgSR9qxggsW6OLo7kCCENRBrIDBOIFKBsNwdpu0MrBY=";
  version = "unstable-2025-11-07";
  branch = "staging";
}
