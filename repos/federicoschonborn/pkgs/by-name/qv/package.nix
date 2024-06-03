{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  libtgd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qv";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "marlam";
    repo = "qv-mirror";
    rev = "qv-${finalAttrs.version}";
    hash = "sha256-zrpbpifk0cPbdaXfX7I75BFOuTLaoj59lx0aXKOoU8g=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libtgd
    qt6.qtbase
    qt6.qtwayland
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "qv-(.*)"
    ];
  };

  meta = {
    mainProgram = "qv";
    description = "A a viewer for 2D data such as images, sensor data, simulations, renderings and videos";
    homepage = "https://marlam.de/qv/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    # maintainers = [ lib.maintainers.federicoschonborn ];
  };
})