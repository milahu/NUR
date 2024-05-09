{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "moss";
  version = "nightly-20240503-005240-unstable-2024-04-30";

  src = fetchFromGitHub {
    owner = "serpent-os";
    repo = "moss";
    rev = "968c6136dc5d06f066a317d773ba9c43caf6deed";
    hash = "sha256-gCANqQvf1uzDcTq6rTHplYw0GifDqBlM5mS7kpb1lnc=";
  };

  cargoHash = "sha256-fJeFziCeb6GmuaehPM87Y7PZfd+caXYdbbGbO4+JJus=";

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
