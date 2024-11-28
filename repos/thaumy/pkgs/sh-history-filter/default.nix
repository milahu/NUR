{ lib
, pkgs
, rustPlatform
, fetchFromGitHub
}:

let
  appBinName = "sh-history-filter";
  appVersion = "0.0.4";
  appComment = "Filter your shell history";

  rust-overlay = import (fetchFromGitHub {
    owner = "oxalica";
    repo = "rust-overlay";
    rev = "e19e9d54fac1e53f73411ebe22d19f946b1ba0bd";
    sha256 = "sha256-pULo7GryzLkqGveWvnNWVz1Kk6EJqvq+HQeSkwvr7DA=";
  });

  toolchain = (pkgs.extend rust-overlay).rust-bin.nightly."2024-10-21".minimal;

  src = fetchFromGitHub {
    owner = "Thaumy";
    repo = "sh-history-filter";
    rev = "8200dea3d43801eb1ec2b62227eab9e535515d68";
    sha256 = "sha256-hueHjhY1e6he6p2Lah8/eMb8JO5I58t69HZFBPnjWW4=";
  };

  buildTimeDeps = [
    toolchain
  ];
in
rustPlatform.buildRustPackage {
  pname = appBinName;
  version = appVersion;

  nativeBuildInputs = buildTimeDeps;

  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  buildPhase = ''
    cp -r ${src}/* .
    cargo build -r
  '';

  installPhase = ''
    # bin
    mkdir -p $out/bin
    cp target/release/${appBinName} $out/bin

    # echo for debug
    echo -e "\nApp was successfully installed in $out\n"
  '';

  meta = {
    description = appComment;
    homepage = "https://github.com/Thaumy/sh-history-filter";
    license = lib.licenses.mit;
    maintainers = [ "thaumy" ];
    platforms = lib.platforms.linux;
  };
}
