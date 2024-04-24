{ lib
, rustPlatform'
, maa-cli
, fetchFromGitHub
, maa-assistant-arknights
, stdenv
}:
let
  sources = lib.importJSON ./pin.json;
in
rustPlatform'.buildRustPackage rec {
  pname = "maa-cli";
  version = sources.maa-cli.name;

  src = fetchFromGitHub {
    owner = "MaaAssistantArknights";
    repo = "maa-cli";
    rev = "${sources.maa-cli.version}";
    hash = sources.maa-cli.hash;
  };

  nativeBuildInputs = maa-cli.nativeBuildInputs;

  buildInputs = maa-cli.buildInputs;

  buildNoDefaultFeatures = maa-cli.buildNoDefaultFeatures;
  buildFeatures = maa-cli.buildFeatures;

  cargoLock = {
    lockFile = "${src.out}/Cargo.lock";
  };

  postInstall = maa-cli.postInstall;

  meta = maa-cli.meta // {
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}