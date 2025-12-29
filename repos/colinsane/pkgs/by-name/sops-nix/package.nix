{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2025-12-28";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "61b39c7b657081c2adc91b75dd3ad8a91d6f07a7";
    hash = "sha256-pn8AxxfajqyR/Dmr1wnZYdUXHgM3u6z9x0Z1Ijmz2UQ=";
  };
  flake = import "${src}/flake.nix";
  evaluated = flake.outputs {
    self = evaluated;
    nixpkgs = pkgs;
  };
  overlay = evaluated.overlays.default;
  final = pkgs.extend overlay;
in src.overrideAttrs (base: {
  # attributes required by update scripts
  pname = "sops-nix";
  src = src;
  version = version;

  passthru = base.passthru
    // (overlay final pkgs)
    // { inherit (evaluated) nixosModules; }
    // {
      updateScript = nix-update-script {
        extraArgs = [ "--version" "branch" ];
      };
    }
  ;
})
