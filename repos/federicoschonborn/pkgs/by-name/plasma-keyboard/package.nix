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
  version = "0-unstable-2025-08-23";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-keyboard";
    rev = "67320438b00755a8937f79fa7cf0badfc25e57d0";
    hash = "sha256-u0HloA1gKE7PhKF0B9gzg5w9B7pN5N0XBzX6w2qUp5w=";
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
