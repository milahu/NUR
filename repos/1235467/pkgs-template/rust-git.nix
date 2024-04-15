{ lib
, fetchFromGitHub
, rustPlatform
, ffmpeg
, pkg-config
, git
, ...
}:
let
  pname = "Anime4K-rs";
  version = "v0.1";
  sha256 = "sha256-OGExO+DaIONfzNbRX4QJMdeZc3S4NQDt9YaL0jC0Nvk=";
  cargoHash = "";
in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash;

  src = fetchFromGitHub {
    owner = "andraantariksa";
    repo = pname;
    rev = version;
    inherit sha256;
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "raster-0.2.1" = "sha256-V1QDXECg64zamrL+hEE74FBAIjwjeVDvWhgdezM0MIo=";

    };
  };

  nativeBuildInputs = [
    pkg-config
    git
  ];

  buildInputs = [
    ffmpeg
  ];

  meta = with lib; {
    description = "An attempt to write Anime4K in Rust";
    homepage = "https://github.com/andraantariksa/Anime4K-rs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
