{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  src = fetchFromGitHub {
    owner = "ultraworkers";
    repo = "claw-code";
    rev = "main";
    hash = "sha256-4cc14TtAhbXWsI/F9Drem2bErWMuOtG5JgD8H5m12DA=";
  };
in
rustPlatform.buildRustPackage {
  pname = "claw";
  version = "0.1.3";

  inherit src;

  cargoLock.lockFile = "${src}/rust/Cargo.lock";

  sourceRoot = "${src.name}/rust";

  cargoBuildFlags = [ "-p" "rusty-claude-cli" ];

  doCheck = false;

  meta = {
    description = "Rust implementation of the claw CLI agent harness for Claude";
    homepage = "https://github.com/ultraworkers/claw-code";
    license = lib.licenses.mit;
    mainProgram = "claw";
  };
}
