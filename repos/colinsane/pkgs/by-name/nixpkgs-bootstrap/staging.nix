{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "e86e8f2ab5832683f17e7893b3c0b97236a15832";
  sha256 = "sha256-YUjXDD4b7DwyxQgBdEljIZhwS5mALtfORP3xCAz6EOY=";
  version = "unstable-2025-11-06";
  branch = "staging";
}
