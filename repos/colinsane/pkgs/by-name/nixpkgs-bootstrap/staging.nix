{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "27a49dc3c9a88733aa1d0371ecfec2e13d311347";
  sha256 = "sha256-57oyfjqiAp+wCGFuvPHVzRoft7AFgXLe4xz8Sub60SA=";
  version = "0-unstable-2025-03-08";
  branch = "staging";
}
