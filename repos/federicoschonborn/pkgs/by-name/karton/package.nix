{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  pkg-config,
  python3,
  libosinfo,
  libvirt,
  spice-gtk,
  spice-protocol,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "karton";
  version = "0.1-prealpha-unstable-2025-08-21";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sitter";
    repo = "karton";
    rev = "c7cc9d9dc5005145517569ecfc25a0566f3f9a22";
    hash = "sha256-oq7sIP9+TmEtX4igUy8J0I27j1A6Zw9Xn8MlKUlyLLI=";
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
    kdePackages.kirigami
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtmultimedia
    libosinfo
    libvirt
    spice-gtk
    spice-protocol
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "ecm_find_qmlmodule(org.kde.kirigami REQUIRED)" "ecm_find_qmlmodule(org.kde.kirigami)"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "karton";
    description = "KDE Virtual Machine Manager";
    homepage = "https://invent.kde.org/sitter/karton";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
