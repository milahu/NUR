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
  nix-update-script,
  withDefaultCores ? true,
  withDefaultUnfreeCores ? false,
  extraCores ? [ ],
}:

let
  # We don't seem to have gearsystem core yet...
  defaultCores = lib.filter (core: lib.meta.availableOn stdenv.hostPlatform core) (
    lib.optionals withDefaultCores [
      libretro.beetle-gba
      libretro.nestopia
      libretro.blastem
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
  version = "0-unstable-2025-06-27";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "games";
    repo = "kretro";
    rev = "cfd3f27b1e794aa7015c1d5e6dd595f0ca4a3202";
    hash = "sha256-tNvNVYlx99/EWAo0VdWaWJr4MFCJAKOafskrWH9fzMI=";
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
