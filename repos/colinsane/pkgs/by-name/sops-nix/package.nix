{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2025-12-21";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "9836912e37aef546029e48c8749834735a6b9dad";
    hash = "sha256-BOKCwOQQIP4p9z8DasT5r+qjri3x7sPCOq+FTjY8Z+o=";
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
