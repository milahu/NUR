{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gettext,
  ninja,
  pkg-config,
  libxcrypt,
  kde1-kdelibs,
  openssl,
  qt1,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde1-kdebase";
  version = "0-unstable-2022-01-02";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "historical";
    repo = "kde1-kdebase";
    rev = "4987e047002f9b8364c16fa0e6650717c24bcc7e";
    hash = "sha256-r1ac4Srvugg97elR8MgimrO54EfFla0M6eiyxbVagwU=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    ninja
    pkg-config
  ];

  buildInputs = [
    kde1-kdelibs
    libxcrypt
    openssl
    qt1
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
    xorg.libXpm
    xorg.libXt
  ];

  # Lots of broken translation files.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "add_subdirectory(po)" ""
    substituteInPlace kcheckpass/CMakeLists.txt --replace-fail "SETUID" ""
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_MODULE_PATH" "${kde1-kdelibs}/share/cmake/Modules")
    (lib.cmakeFeature "KDE1_INCLUDE_DIR" "${kde1-kdelibs}/include/kde1")
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-fpermissive"
    "-Wno-unused-result"
    "-Wno-incompatible-pointer-types"
    "-Wno-deprecated-declarations"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Historical copy of the base applications module of KDE 1, adapted to compile on modern systems (circa. 2016";
    homepage = "https://invent.kde.org/historical/kde1-kdebase";
    changelog = "https://invent.kde.org/historical/kde1-kdebase/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ federicoschonborn ];
    platforms = lib.platforms.linux;
  };
})
