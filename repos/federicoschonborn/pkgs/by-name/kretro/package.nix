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
  version = "0-unstable-2025-08-04";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "games";
    repo = "kretro";
    rev = "be4d65e3e40b2862c18ee25a9d5c3e2c735c27ac";
    hash = "sha256-Jm8LlhEYN4ysfN9h6EbiKmL4mSqg3XQah2N2XVXGsCc=";
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
    paths = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
      [
        libretro.beetle-gba
        libretro.nestopia
        libretro.blastem
        gearsystem-libretro
      ]
      ++ lib.optionals withUnfreeCores [
        libretro.snes9x
      ]
    );
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
