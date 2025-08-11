{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  SDL2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gearsystem";
  version = "3.8.3";

  src = fetchFromGitHub {
    owner = "drhelius";
    repo = "Gearsystem";
    tag = finalAttrs.version;
    hash = "sha256-IRfGOnKuqps121WU2vzRTvp6vG/EtwNXDwDDEq+WqO8=";
  };

  nativeBuildInputs = [
    pkg-config
    SDL2 # sdl2-config
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux wrapGAppsHook3;

  buildInputs = [
    SDL2
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gtk3;

  strictDeps = true;

  postPatch = ''
    substituteInPlace platforms/desktop-shared/Makefile.common \
      --replace-fail "sdl2-config --static-libs" "sdl2-config --libs"
  '';

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
    changelog = "https://github.com/drhelius/Gearsystem/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
