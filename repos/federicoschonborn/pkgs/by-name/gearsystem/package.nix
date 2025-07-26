{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  glew,
  gtk3,
  SDL2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gearsystem";
  version = "3.8.2";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearsystem";
    tag = finalAttrs.version;
    hash = "sha256-sty6dHq4Ad8XOqwSXau/JNHGDl6XZWf5/34VB967PVs=";
  };

  nativeBuildInputs = [
    pkg-config
    SDL2 # sdl2-config
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux wrapGAppsHook3;

  buildInputs = [
    glew
    SDL2
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gtk3;

  strictDeps = true;

  makeFlags = [
    "-C"
    "platforms/linux"
    "prefix=$(out)"
    "GIT_VERSION=${finalAttrs.src.tag}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "gearsystem";
    description = "Sega Master System/Game Gear/SG-1000 emulator and debugger for macOS, Windows, Linux, BSD and RetroArch";
    homepage = "https://github.com/drhelius/Gearsystem";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
