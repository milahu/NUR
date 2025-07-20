{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  alsa-lib,
  sdl3,
  symlinkJoin,
  libretro,
  gearsystem-libretro,
  nix-update-script,
  withUnfreeCores ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kretro";
  version = "0-unstable-2025-07-19";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "games";
    repo = "kretro";
    rev = "6589376c3fa2de412dbc9d375a63d6e746bb7db1";
    hash = "sha256-mms88GOxDsltckhUNv0KgmmMZBaH39ybyk8tRxwDmkE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    sdl3
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    kdePackages.qtsvg
  ];

  libretroCores = symlinkJoin {
    name = "${lib.getName finalAttrs.finalPackage}-cores-${lib.getVersion finalAttrs.finalPackage}";
    paths =
      [
        libretro.beetle-gba
        libretro.nestopia
        libretro.blastem
        gearsystem-libretro
      ]
      ++ lib.optionals withUnfreeCores [
        libretro.snes9x
      ];
  };

  postPatch = ''
    substituteInPlace src/kretroconfig.kcfg \
      --replace-fail "/usr/lib/libretro" "${finalAttrs.libretroCores}/lib/retroarch/cores"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "kretro";
    description = "Libretro Emulation Frontend for Plasma";
    homepage = "https://invent.kde.org/games/kretro";
    license = with lib.licenses; [
      bsd3
      cc-by-sa-40
      cc0
      gpl2Plus
      lgpl2Plus
      mit
      unlicense
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
