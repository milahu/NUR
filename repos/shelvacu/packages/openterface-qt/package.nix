{
  lib,

  qt6,
  stdenv,
  libusb1,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "openterface-qt";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "TechxArtisanStudio";
    repo = "Openterface_QT";
    rev = "${version}";
    hash = "sha256-yD71UOi6iRd9N3NeASUzqoeHMcTYIqkysAfxRm7GkOA=";
  };

  nativeBuildInputs = with qt6; [
    wrapQtAppsHook
    qmake
  ];

  buildInputs =
    (with qt6; [
      qtbase
      qtmultimedia
      qtserialport
      qtsvg
    ])
    ++ [ libusb1 ];

  preInstall = ''
    mkdir -p "$out"/bin
    cp ./openterfaceQT "$out"/bin/openterface-qt
  '';

  meta = {
    description = "Client software for Openterface Mini-KVM";
    homepage = "https://openterface.com/app/qt/";
    changelog = "https://github.com/TechxArtisanStudio/Openterface_QT/releases";
    license = [ lib.licenses.agpl3Only ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "openterface-qt";
    platforms = lib.platforms.all;
  };
}
