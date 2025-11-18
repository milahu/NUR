{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "b83ccc4eaf361647ceb5194e2cf85adff6c2b58f";
  sha256 = "sha256-4CezNvbr9uv/lFA8R7Tqgk8rhv3d8jw+wUlW1PVaSgQ=";
  version = "unstable-2025-11-16";
  branch = "staging";
}
