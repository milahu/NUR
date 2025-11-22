{ pkgs
, fetchFromGitHub
, lib
, nix-update-script
}:
let
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixpkgs-wayland";
    rev = "ecbff9f5287b9a48068ce3e1ccb5a3bb136cf6ca";
    hash = "sha256-yHkuuPby8xtaZXbDb7IgXjyYhWEofecseDVP7SKQuYY=";
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
  version = "0-unstable-2025-11-20";
  src = src;

  # passthru only nixpkgs-wayland's own packages -- not the whole nixpkgs-with-nixpkgs-wayland-as-overlay:
  passthru = base.passthru // (overlay final pkgs) // {
    updateScript = nix-update-script {
      extraArgs = [ "--version" "branch" ];
    };
  };
})
