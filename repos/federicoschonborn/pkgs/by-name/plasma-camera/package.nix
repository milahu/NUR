{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  pkg-config,
  python3,
  libcamera,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "plasma-camera";
  version = "1.0-unstable-2025-07-06";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-mobile";
    repo = "plasma-camera";
    rev = "46bb52101743241dcb00fae8c30b68ddc61eec9c";
    hash = "sha256-eQ/OKoGWrVYPWQoZXJgpCNQxOMCJO4Ez7ldKV8ou4Lg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    libcamera
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "plasma-camera";
    description = "Camera application for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-camera";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
