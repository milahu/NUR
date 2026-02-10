{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  version = "0-unstable-2026-02-08";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-wayland";
    rev = "c1d44e8d60680abc85081f6a3ada7802b6c0fca3";
    hash = "sha256-ajvQ8ZQWe+J8T6ejPWhssqRcXuIBpSq4cRZTvNmbSs4=";
  };
  overlay = import "${src}/overlay.nix";

  final = pkgs.extend overlay;
in src.overrideAttrs (base: {
  # attributes required by update scripts
  pname = "nixpkgs-wayland";
  src = src;
  version = version;

  # passthru only nixpkgs-wayland's own packages -- not the whole nixpkgs-with-nixpkgs-wayland-as-overlay:
  passthru = base.passthru // (overlay final pkgs) // {
    inherit overlay;
    updateScript = nix-update-script {
      extraArgs = [ "--version" "branch" ];
    };
  };
})
