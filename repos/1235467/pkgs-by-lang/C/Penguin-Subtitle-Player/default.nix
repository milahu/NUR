{ lib, fetchFromGitHub, pkg-config, wrapGAppsHook, wrapQtAppsHook, qtbase, fontconfig, freetype, libglvnd, mkDerivation, ... }:

mkDerivation rec {
  pname = "Penguin-Subtitle-Player";
  version = "e54f0c16279914eacb6ae609f20992285db8808f";

  src = fetchFromGitHub {
    owner = "carsonip";
    repo = pname;
    rev = version;
    hash = "sha256-AhdShg/eWqF44W1r+KmcHzbGKF2TNSD/wPKj+x4oQkM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook wrapQtAppsHook fontconfig freetype libglvnd qtbase ];
  buildInputs = [ qtbase ];

  dontWrapGApps = false;

  # Arguments to be passed to `makeWrapper`, only used by qt5’s mkDerivation
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  installPhase = ''
    qmake "PenguinSubtitlePlayer.pro"
    make
    mkdir -p $out/bin
    ls -la build/
    cd build/release
    install -D -m 755 PenguinSubtitlePlayer $out/bin/PenguinSubtitlePlayer
  '';
  postInstall = ''

  '';

  #   meta = with lib; {
  #     description = "On screen lyrics for Wayland with NetEase Music source";
  #     homepage = "https://github.com/poly000/waylyrics";
  #     license = licenses.mit;
  #     maintainers = [ maintainers.shadowrz ];
  #     platforms = platforms.linux;
  #   };
}
