{ lib
, pkgs
, rustPlatform
, fetchFromGitHub
}:

let
  appBinName = "dup-img-finder";
  appVersion = "0.2.0";
  appComment = "Find duplicate images by similarity";

  rust-overlay = import (fetchFromGitHub {
    owner = "oxalica";
    repo = "rust-overlay";
    rev = "e19e9d54fac1e53f73411ebe22d19f946b1ba0bd";
    sha256 = "sha256-pULo7GryzLkqGveWvnNWVz1Kk6EJqvq+HQeSkwvr7DA=";
  });

  toolchain = (pkgs.extend rust-overlay).rust-bin.nightly."2024-10-21".minimal;

  src = fetchFromGitHub {
    owner = "Thaumy";
    repo = "dup-img-finder";
    rev = "48975af031628d22d628fff7a6f36925e8929286";
    hash = "sha256-Ox14MnKoWNYn9WoMM7pSrQhibl/VUoKytbS8PDEnxkk==";
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
    homepage = "https://github.com/Thaumy/dup-img-finder";
    license = lib.licenses.mit;
    maintainers = [ "thaumy" ];
    platforms = lib.platforms.linux;
  };
}
