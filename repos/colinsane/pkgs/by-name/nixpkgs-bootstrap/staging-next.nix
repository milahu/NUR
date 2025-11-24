{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "5f55125d5445c04d7319dc5e5c53490674115e53";
  sha256 = "sha256-E9RvTs8SOL5geySkcvLSQBAsFcmWSxbp09FT3eeq0ZA=";
  version = "unstable-2025-11-23";
  branch = "staging-next";
}
