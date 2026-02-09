{
  fetchFromGitHub,
  flake-compat,
  nix-update-script,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2026-01-26";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "c5eebd4eb2e3372fe12a8d70a248a6ee9dd02eff";
    hash = "sha256-wFcr32ZqspCxk4+FvIxIL0AZktRs6DuF8oOsLt59YBU=";
  };
  flake = flake-compat {
    inherit src;
  };
in flake.outputs.overrideAttrs (base: {
  # attributes required by update scripts.
  # the main output of this derivation is `pkgs.sops-nix.nixosModules.sops`.
  pname = "sops-nix";
  src = src;
  version = version;

  passthru = base.passthru // flake.outputs // {
    inherit flake;
    updateScript = nix-update-script {
      extraArgs = [ "--version" "branch" ];
    };
  };
})
