{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e034fcf7e9082a5050894579b77e569f3c419299";
  sha256 = "sha256-Ao1veOKMDmkJEc715yduOJs1Ux8IvNrcqHY1rxMSq3M=";
  version = "unstable-2025-11-24";
  branch = "staging";
}
