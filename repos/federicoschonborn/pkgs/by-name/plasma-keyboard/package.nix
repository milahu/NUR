{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "plasma-keyboard";
  version = "0-unstable-2025-07-11";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-keyboard";
    rev = "51e4641cb652f121f8c5eebb2dcd133ac74eb776";
    hash = "sha256-A4D0FWZbt7D/cW8YWp6AJLWGXI+7i8veb1GrV4FZh2E=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    kdePackages.kcmutils
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.qtbase
    kdePackages.qtvirtualkeyboard
    kdePackages.qtwayland
  ];

  cmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${kdePackages.qtwayland}/libexec/qtwaylandscanner"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "plasma-keyboard";
    description = "Virtual Keyboard for Qt based desktops";
    homepage = "https://invent.kde.org/plasma/plasma-keyboard";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      lgpl21Only
      lgpl3Only
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
