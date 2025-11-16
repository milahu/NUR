{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "992b9feb3f3e6a87e762ce5b75361ae6d1bfafd8";
  sha256 = "sha256-nPjFab/9E0QkSiWDMgxG724k8BjloQii/htADiELDtw=";
  version = "unstable-2025-11-13";
  branch = "staging";
}
