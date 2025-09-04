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
  version = "0-unstable-2025-09-02";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "knighttime";
    rev = "4d5b34bc78039015809422ce0d3a9809dfd3ba16";
    hash = "sha256-CdPqVH05KxPDRDpcuNDpPY66uXRzY5RPUTkkqab5Lj8=";
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
