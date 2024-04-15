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
,
}:
let
  pname = "av1an";
  version = "0.4.1";

  sha256 = "0sqq0wwmxyrs6dy5i16qzf3fhsgwnbyq4kl81hvsjr2h6r8811ix";

  cargoHash = "sha256-mfI6pMQaWkXCjcjtgUhm6K0UeGSAZ5QJXsrmmFEhoFM=";
in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash;

  src = fetchFromGitHub {
    owner = "master-of-zen";
    repo = pname;
    rev = version;
    inherit sha256;
  };

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
