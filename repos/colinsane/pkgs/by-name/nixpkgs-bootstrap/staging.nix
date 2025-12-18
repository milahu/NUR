{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "488c53eaf428d80ec1ccf18a3e386e9d96b5cfe7";
  sha256 = "sha256-Rwfu8rLgBXGe0RJ2e4RPEJIp/n7E1S6YGYcXJGr4NEI=";
  version = "unstable-2025-12-17";
  branch = "staging";
}
