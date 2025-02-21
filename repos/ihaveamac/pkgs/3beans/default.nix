{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wxGTK32,
  portaudio,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "3beans";
  version = "0-unstable-2025-02-20";

  src = fetchFromGitHub {
    owner = "Hydr8gon";
    repo = "3Beans";
    rev = "8b78ee214b7fdcc36131da7679fb035e54491ed1";
    hash = "sha256-WsQCZPoKlfYhMXb1ajaYqGd9AB05p5OuZ1WtKZMFX3c=";
  };

  buildInputs = [
    (wxGTK32.override { withWebKit = false; })
    portaudio
    libGL
  ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail g++ "\$(CXX)"
  '';

  installPhase =
    ''
      mkdir -p $out/bin $out/share/applications
      cp 3beans $out/bin
    ''
    + (lib.optionalString (!stdenv.isDarwin) ''
      cp com.hydra.threebeans.desktop $out/share/applications
    '');

  meta = with lib; {
    license = licenses.gpl3;
    description = "A low-level 3DS emulator (maybe)";
    homepage = "https://github.com/Hydr8gon/3Beans";
    platforms = platforms.all;
    mainProgram = "3beans";
  };
}
