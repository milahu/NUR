{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "4299dcd22961b0c17b53356b25e01d5b0677e70b";
  sha256 = "sha256-XMo71Rni9R4ySPRLOjYNx2OW6OWXQMHWScWNls5r13U=";
  version = "unstable-2025-11-24";
  branch = "staging-next";
}
