{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  alsa-lib,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "kretro";
  version = "0-unstable-2025-06-26";

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
    maintainers = with lib.maintainers; [ federicoschonborn ];
    platforms = lib.platforms.linux;
  };
}
