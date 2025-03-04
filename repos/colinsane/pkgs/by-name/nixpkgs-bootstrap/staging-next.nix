{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
  ...
}@args:
mkNixpkgs ({
  rev = "749375426d72ead4bdac625818e7be62a6bbbaf4";
  sha256 = "sha256-IDxPfbSdIy7XAP1hneGOfr2jsj+hFUsvFhpRksYqols=";
  version = "0-unstable-2025-02-28";
  branch = "staging-next";
} // args)
