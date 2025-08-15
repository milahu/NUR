{
  bobgen,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
bobgen.overrideAttrs
(final: prev: {
  version = "0.40.1-unstable-2025-08-14";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    rev = "0284620cea53058ed23e3c3b5a0bbfccfaf21758";
    hash = "sha256-qqJ1d6lD61cP7NjtNuNHuc9NcB6g9HA+gG2voZGRP4E=";
  };

  vendorHash = "sha256-3K5ByPBrZRsLcmp0JMNLCcLqQdQizTdxN1Q7B4xe9vc=";

  passthru = {
    updateScript = lib.concatStringsSep " " (nix-update-script {
      extraArgs = [
        "--commit"
        "--version=branch=main"
        "${final.pname}.unstable"
      ];
    });
  };

  meta =
    prev.meta
    // {
      description = "${prev.meta.description} - main branch";
      changelog = "https://github.com/stephenafamo/bob/commits/${final.src.rev}/";
    };
})
