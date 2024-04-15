# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchzip, fetchFromGitHub, dockerTools }:
{
  cakeml = {
    pname = "cakeml";
    version = "v2274";
    src = fetchzip {
      url = "https://github.com/CakeML/cakeml/releases/download/v2274/cake-x64-64.tar.gz";
      sha256 = "sha256-etPOxeW9jY3kltsqoj8jthmggDt8eQdmJcF0p3YDACs=";
    };
  };
  enso = {
    pname = "enso";
    version = "2024.1.1-nightly.2024.3.26";
    src = fetchurl {
      url = "https://github.com/enso-org/enso/releases/download/2024.1.1-nightly.2024.3.26/enso-linux-x86_64-2024.1.1-nightly.2024.3.26.AppImage";
      sha256 = "sha256-umZw7nAeRoHzos8xYmCJMflN0zcmLj17y3sYgwN14dQ=";
    };
  };
  guile-config = {
    pname = "guile-config";
    version = "0.5.0";
    src = fetchzip {
      url = "https://gitlab.com/a-sassmannshausen/guile-config/-/archive/0.5.0/guile-config-0.5.0.tar.gz";
      sha256 = "sha256-8Ma2pzqR8il+8H6WVbYLpKBk2rh3aKBr1mvvzdpCNPc=";
    };
  };
  guile-hall = {
    pname = "guile-hall";
    version = "0.4.1";
    src = fetchzip {
      url = "https://gitlab.com/a-sassmannshausen/guile-hall/-/archive/0.4.1/guile-hall-0.4.1.tar.gz";
      sha256 = "sha256-TUCN8kW44X6iGbSJURurcz/Tc2eCH1xgmXH1sMOMOXs=";
    };
  };
  seamonkey = {
    pname = "seamonkey";
    version = "2.53.18.2";
    src = fetchzip {
      url = "https://archive.seamonkey-project.org/releases/2.53.18.2/linux-x86_64/en-US/seamonkey-2.53.18.2.en-US.linux-x86_64.tar.bz2";
      sha256 = "sha256-sgkEhgyWMisyrK/ZxlgbpMKZV9/AdbcyjbsjYZhY0k0=";
    };
  };
  trufflesqueak = {
    pname = "trufflesqueak";
    version = "23.1.0";
    src = fetchurl {
      url = "https://github.com/hpi-swa/trufflesqueak/releases/download/23.1.0/trufflesqueak-23.1.0-linux-amd64.tar.gz";
      sha256 = "sha256-wdFfNHgcRYKMOVbfjo2j8IRu5+izMNQK1tUXX1vFwtA=";
    };
  };
  trufflesqueak-image = {
    pname = "trufflesqueak-image";
    version = "23.1.0";
    src = fetchurl {
      url = "https://github.com/hpi-swa/trufflesqueak/releases/download/23.1.0/TruffleSqueakImage-23.1.0.zip";
      sha256 = "sha256-/9rbH9hEHSgaOUbSHpDCdmCX4m+myxVIgG6Nf5r85Zg=";
    };
  };
  wasmfxtime = {
    pname = "wasmfxtime";
    version = "b783f55bd8c287241b5a623c159aa134c9b3b9e9";
    src = fetchFromGitHub {
      owner = "wasmfx";
      repo = "wasmfxtime";
      rev = "b783f55bd8c287241b5a623c159aa134c9b3b9e9";
      fetchSubmodules = true;
      sha256 = "sha256-ZNhoUY1Fx9B6xhfhGrjBrdtLh2ASRcEGy/8KBgscQpI=";
    };
    cargoLock."./Cargo.lock" = {
      lockFile = ./wasmfxtime-b783f55bd8c287241b5a623c159aa134c9b3b9e9/./Cargo.lock;
      outputHashes = {
        "wasm-encoder-0.202.0" = "sha256-kmDsebivrx2irch2T/giJ5TLCxiM1CKrpvaWeK++yTw=";
        "wit-bindgen-0.22.0" = "sha256-UrJ0NR3h48LajjHPLr9rJFaSU+qr9hYv/0d/ghl5rGs=";
        "wasm-encoder-0.201.0" = "sha256-uDU6dJPY4ymtFK8bOVG25TohRFc0m78U0m1oAlooCME=";
      };
    };
    date = "2024-04-12";
  };
}
