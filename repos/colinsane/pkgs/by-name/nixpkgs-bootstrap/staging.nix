{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "dd4fe9226477a2ca666c4a831a5eef6f593c24b7";
  sha256 = "sha256-5fNpGtBGVnxPSqqgmfTwwqPUSfcapca4hAOx18ylZew=";
  version = "0-unstable-2025-02-26";
  branch = "staging";
}
