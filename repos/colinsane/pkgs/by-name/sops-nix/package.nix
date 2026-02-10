{
  fetchFromGitHub,
  flake-compat,
  nix-update-script,
}:
let
  # nix-update-script insists on this weird `assets-` version format
  version = "assets-unstable-2026-02-08";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "sops-nix";
    rev = "d6e0e666048a5395d6ea4283143b7c9ac704720d";
    hash = "sha256-xbvX5Ik+0inJcLJtJ/AajAt7xCk6FOCrm5ogpwwvVDg=";
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
