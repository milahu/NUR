{ lib
, fetchFromGitHub
, rustPlatform
, callPackage
  #, ffmpeg
, ...
}:
let
  pname = "ncmdump.rs";
  sources = callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.ncmdump_rs) version src;
  cargoLock.lockFile = "${sources.ncmdump_rs.src}/Cargo.lock";

  nativeBuildInputs = [
    #pkg-config
  ];

  buildInputs = [
    #ffmpeg
    #git
    #libvmaf
    #svt-av1
  ];

  meta = with lib; {
    description = "netease cloud music copyright protection file dump by rust";
    homepage = "https://github.com/iqiziqi/ncmdump.rs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
