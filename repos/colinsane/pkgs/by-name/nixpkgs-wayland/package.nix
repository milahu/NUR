{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  version = "0-unstable-2026-01-31";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-wayland";
    rev = "ac07e3fc6ffdff74760eb5f13c8934aacc415e39";
    hash = "sha256-+HSkyWk3521nmA5wYyJDLmJAEwsLKWUCPaSylxSK0XE=";
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
