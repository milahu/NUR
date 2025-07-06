{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  glew,
  gtk3,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gearsystem";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearsystem";
    tag = finalAttrs.version;
    hash = "sha256-eRZMLspDfghsRtR/QpTHxXh6uItPzlCnLfWPd3dRp/8=";
  };

  nativeBuildInputs = [
    pkg-config
    SDL2 # sdl2-config
  ] ++ lib.optional stdenv.hostPlatform.isLinux wrapGAppsHook3;

  buildInputs = [
    glew
    SDL2
  ] ++ lib.optional stdenv.hostPlatform.isLinux gtk3;

  strictDeps = true;

  makeFlags = [
    "-C"
    "platforms/linux"
    "prefix=$(out)"
    "GIT_VERSION=${finalAttrs.src.tag}"
  ];

  meta = {
    mainProgram = "gearsystem";
    description = "Sega Master System/Game Gear/SG-1000 emulator and debugger for macOS, Windows, Linux, BSD and RetroArch";
    homepage = "https://github.com/drhelius/Gearsystem";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
