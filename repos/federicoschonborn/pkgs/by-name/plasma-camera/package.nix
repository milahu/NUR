{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  pkg-config,
  libcamera,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-camera";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-mobile";
    repo = "plasma-camera";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5sAYhECgjL768E3NXeE8ExKhrntWrQeaeNgQQr25TBM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    libcamera
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    kdePackages.qtsensors
    kdePackages.qtsvg
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "plasma-camera";
    description = "libcamera based camera application built for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-camera";
    changelog = "https://invent.kde.org/plasma-mobile/plasma-camera/-/tags/v${finalAttrs.version}";
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus
      lgpl21Plus
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
