{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "moss";
  version = "nightly-20240514-005034-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "serpent-os";
    repo = "moss";
    rev = "931a4f58a6db5b19d0c0739ef633141498acdb5b";
    hash = "sha256-gds6HDH4RVXSQXgRZq241TF/AaoINPOSYNbAlZZ8WWM=";
  };

  cargoHash = "sha256-CDBSATK9grySyLSdh/tYt9TMtA/K81qNDJkwej/dugY=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    mainProgram = "moss";
    description = "The safe, fast and sane package manager for Linux";
    homepage = "https://github.com/serpent-os/moss";
    license = lib.licenses.mpl20;
    broken = lib.versionOlder rustPlatform.rust.rustc.version "1.74";
  };
}
