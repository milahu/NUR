{
  mkNixpkgs ? import ./mkNixpkgs.nix {}
}:
mkNixpkgs {
  rev = "e3ca8012e9514272e5c7959768193a68e0bf1521";
  sha256 = "sha256-dJXMnhq/xvHQCjmESBwzd1o0LbBotQiQZsE8LP/aoaw=";
  version = "0-unstable-2024-12-03";
  branch = "master";
}
