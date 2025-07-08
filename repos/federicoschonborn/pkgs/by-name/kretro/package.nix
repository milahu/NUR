{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  alsa-lib,
  symlinkJoin,
  libretro,
  gearsystem-libretro,
  nix-update-script,
  withDefaultCores ? true,
  withDefaultUnfreeCores ? false,
  extraCores ? [ ],
}:

let
  defaultCores = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
    lib.optionals withDefaultCores [
      libretro.beetle-gba
      libretro.nestopia
      libretro.blastem
      gearsystem-libretro
    ]
    ++ lib.optionals withDefaultUnfreeCores [
      libretro.snes9x
    ]
  );
  extraCores' = if lib.isFunction extraCores then extraCores libretro else extraCores;
  allCores = defaultCores ++ extraCores';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kretro";
  version = "0-unstable-2025-07-06";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "games";
    repo = "kretro";
    rev = "57995051540e0a74c61fc7f9fefdca1706a3f455";
    hash = "sha256-9wwTYIBPBxNfixF57ppsamEjUSE5jPzRgS+YGB6IlSo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
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
    name = "${lib.getName finalAttrs.finalPackage}-${lib.getVersion finalAttrs.finalPackage}-cores";
    paths = allCores;
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
