{
  nix-update,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
nix-update.overrideAttrs
(final: prev: {
  version = "1.13.1-unstable-2025-09-29";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-update";
    rev = "be8090e472fe7e1945228cb4d913381147870139";
    hash = "sha256-/ZY/1zq4wbc7Gr4Yy1RtUWpG1KFQMkyWseQGpwFKyaM=";
  };

  passthru =
    prev.passthru
    // {
      updateScript = lib.concatStringsSep " " (nix-update-script {
        extraArgs = [
          "--commit"
          "--version=branch=main"
          "${final.pname}"
        ];
      });
    };

  meta =
    prev.meta
    // {
      description = "${prev.meta.description} - main branch";
      changelog = "https://github.com/Mic92/nix-update/commits/${final.src.rev}/";
    };
})
