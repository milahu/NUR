{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "kiss";
  version = "0-unstable-2025-07-02";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "kiss";
    rev = "d9c1ba6d15ace30f3917a82574e68ab31b857e02";
    hash = "sha256-78YkSnXqd2nbKxpVuvMpwXi+ydYyQZ7zM2qV6L9+6fE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtsvg
    kdePackages.kconfig
    kdePackages.ki18n
    kdePackages.kpackage
    kdePackages.libkscreen
    kdePackages.plasma-desktop
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "kiss";
    description = "KDE Initial System Setup";
    homepage = "https://invent.kde.org/system/kiss";
    license = with lib.licenses; [
      bsd2
      cc0
      gpl2Plus
      gpl3Plus
      lgpl2Plus
      lgpl21Only
      lgpl21Plus
      lgpl3Only
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ federicoschonborn ];
    # Requires changes in newer Plasma Desktop
    # See https://invent.kde.org/plasma/plasma-desktop/-/commit/af50724aeae3ce4429f6af4d83f2e3b52011b66d
    broken = true;
  };
}
