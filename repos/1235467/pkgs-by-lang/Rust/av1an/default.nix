{ lib
, fetchFromGitHub
, rustPlatform
, vapoursynth
, ffmpeg
, x264
, libaom
, rav1e
, nasm
, pkg-config
, python3
, python3Packages
, makeWrapper
, pkgs
,
}:
let
  pname = "av1an";
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.av1an) version src;
  cargoLock.lockFile = "${sources.av1an.src}/Cargo.lock";
  nativeBuildInputs = [
    pkg-config
    nasm
    makeWrapper
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    libaom
    rav1e
  ];

  buildInputs = [
    ffmpeg
    x264
    vapoursynth
    python3Packages.vapoursynth
  ];

  postInstall = ''
    wrapProgram $out/bin/av1an \
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath [ python3Packages.vapoursynth ]}
  '';

  meta = with lib; {
    description = "Cross-platform command-line AV1 / VP9 / HEVC / H264 encoding framework with per scene quality encoding";
    homepage = "https://github.com/master-of-zen/av1an";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
