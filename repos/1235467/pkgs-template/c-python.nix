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
,
}:
let
  pname = "idntag";
  version = "v1.11";

  sha256 = "sha256-vm6EyJwLmvZrpz6EvvHzsXAyi+MpYCOGtSLII8PfO+k=";

in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "d99kris";
    repo = pname;
    rev = version;
    inherit sha256;
  };

  nativeBuildInputs = [
    #pkg-config
    cmake
  ];

  nativeCheckInputs = [
    #libaom
    #rav1e
  ];

  buildInputs = [
    git
    mp3info
    taglib
    chromaprint
    #libchromaprint-tools
    ffmpeg
    python3
    python3Packages.pyacoustid
    python3Packages.pytaglib
    makeWrapper
  ];
  cmakeFlags = [
    # "-DBUILD_SHARED_LIBS=ON"
    # "-DOQS_BUILD_ONLY_LIB=1"
    # "-DOQS_USE_OPENSSL=OFF"
    # "-DOQS_DIST_BUILD=ON"
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
