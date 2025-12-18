{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2025-12-15";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "443a7f2e7e118c4fc63b7fae05ab3080dd0e5c63";
    hash = "sha256-hWRYfdH2ONI7HXbqZqW8Q1y9IRbnXWvtvt/ONZovSNY=";
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
