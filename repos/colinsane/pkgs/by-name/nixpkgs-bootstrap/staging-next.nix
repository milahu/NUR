{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "ca0b878109140f6f5637fcccaa5f2aa192b9c839";
  sha256 = "sha256-AeSmFLeFSQaeivfd9xwEOmD7mdrKkQqTnJmcKtwB/wA=";
  version = "unstable-2025-12-23";
  branch = "staging-next";
}
