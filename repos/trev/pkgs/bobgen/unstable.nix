{
  bobgen,
  fetchFromGitHub,
  nix-update-script,
  lib,
  ...
}:
bobgen.overrideAttrs
(final: prev: {
  version = "0.41.1-unstable-2025-09-27";

  src = fetchFromGitHub {
    owner = "stephenafamo";
    repo = "bob";
    rev = "9d3b4c4b34a4263a9d9a42d1ed92e3aa6805ea30";
    hash = "sha256-+WEJlvjw385Bh7ODol54ThxB1g6M2JwcJr8UJ4ssy78=";
  };

  vendorHash = "sha256-Jqlah37+tfNqsgeL/MnbVUmSfU2JWMJDb9AQrEqXnXU=";

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
