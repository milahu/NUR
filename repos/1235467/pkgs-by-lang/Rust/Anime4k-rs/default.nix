{ lib
, fetchFromGitHub
, rustPlatform
, ffmpeg
, pkg-config
, git
, callPackage
, ...
}:
let
  pname = "Anime4K-rs";
  sources = callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.Anime4K-rs) version src;

  cargoLock = {
    lockFile = "${sources.Anime4K-rs.src}/Cargo.lock";
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
