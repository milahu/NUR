{
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkgs,
}:
let
  version = "0-unstable-2025-12-18";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-wayland";
    rev = "a811fbfa92a5528799f8ccdd3127e052e4f6de02";
    hash = "sha256-SUqd+iGpGdPlVxPdGETK2Xp/I0cAYw2eEZrNSqEJRt8=";
  };
  flake = import "${src}/flake.nix";
  evaluated = flake.outputs {
    self = evaluated;
    lib-aggregate.lib = lib // {
      # mock out flake-utils, which it uses to construct flavored package sets.
      # we only need the overlay (unflavored)
      flake-utils.eachSystem = sys: fn: {};
    };
  };
  overlay = evaluated.overlay;

  final = pkgs.extend overlay;
in src.overrideAttrs (base: {
  # attributes required by update scripts
  pname = "nixpkgs-wayland";
  src = src;
  version = version;

  # passthru only nixpkgs-wayland's own packages -- not the whole nixpkgs-with-nixpkgs-wayland-as-overlay:
  passthru = base.passthru // (overlay final pkgs) // {
    updateScript = nix-update-script {
      extraArgs = [ "--version" "branch" ];
    };
  };
})
