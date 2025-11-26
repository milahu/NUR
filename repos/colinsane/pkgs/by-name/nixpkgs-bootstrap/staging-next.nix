{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "11b89b54b770ff9a24df084887a143a4befd7fe8";
  sha256 = "sha256-y9EQgPz0PbhEO/cUifAvPuiMq4QJ3dV9hRj1hCH/EeU=";
  version = "unstable-2025-11-25";
  branch = "staging-next";
}
