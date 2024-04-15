{ lib
, stdenv
, fetchFromGitHub
, git
, cmake
, mp3info
, taglib
, chromaprint
, #libchromaprint-tools,
  ffmpeg
, #pkg-config,
  python3
, python3Packages
, makeWrapper
, callPackage
,
}:
let
  pname = "idntag";
  sources = callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  inherit pname;
  inherit (sources.idntag) version src;

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
  ];

  buildInputs = [
    git
    mp3info
    taglib
    chromaprint
    ffmpeg
    python3
    python3Packages.pyacoustid
    python3Packages.pytaglib
    makeWrapper
  ];
  cmakeFlags = [
  ];

  postInstall = ''
    wrapProgram $out/bin/idntag \
      --prefix PYTHONPATH : ${python3.pkgs.makePythonPath [
      python3Packages.pyacoustid
      python3Packages.pytaglib
      ]}
  '';

  meta = with lib; {
    description = "Automatically identify, tag and rename audio files on Linux and macOS";
    homepage = "https://github.com/d99kris/idntag";
    license = licenses.mit;
    maintainers = [ ];
  };
}
