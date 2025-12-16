{
  fetchFromGitHub,
  nix-update-script,
  pkgs,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2025-12-14";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "94d8af61d8a603d33d1ed3500a33fcf35ae7d3bc";
    hash = "sha256-fJCnsYcpQxxy/wit9EBOK33c0Z9U4D3Tvo3gf2mvHos=";
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
