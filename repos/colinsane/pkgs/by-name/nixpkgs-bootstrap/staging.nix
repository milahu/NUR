{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "f09e2335e49f8ab3a5c5f5deb72cb3834c16ef11";
  sha256 = "sha256-Iv8mRvr7ZMx+H1cVDaj3oZYGrY66qa6N5mLCqtBVBD4=";
  version = "unstable-2025-11-19";
  branch = "staging";
}
