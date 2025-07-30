{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "knighttime";
  version = "0-unstable-2025-07-28";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "knighttime";
    rev = "d59d77277a1dd64f304240f5b595d9a685e0506e";
    hash = "sha256-em/Q+eT/uoH+Z9yVV/kHvHmOrHENlsHUbcyljqo5SIE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    kdePackages.qttools # qdoc
  ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdbusaddons
    kdePackages.kholidays
    kdePackages.ki18n
    kdePackages.qtbase
    kdePackages.qtpositioning
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "knighttime";
    description = "Helpers for scheduling the dark-light cycle";
    homepage = "https://invent.kde.org/plasma/knighttime";
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Only
      gpl3Only
      lgpl21Only
      lgpl3Only
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
    broken = lib.versionOlder kdePackages.extra-cmake-modules.version "6.16.0";
  };
}
