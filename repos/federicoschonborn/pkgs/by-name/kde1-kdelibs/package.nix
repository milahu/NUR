{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gettext,
  ninja,
  libjpeg,
  libpng,
  libtiff,
  qt1,
  xorg,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde1-kdelibs";
  version = "0-unstable-2022-01-15";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "historical";
    repo = "kde1-kdelibs";
    rev = "eec7a2b34bf3aa14f775be132a9ff9c7767c5f62";
    hash = "sha256-HL72OtfVvIHK4rB3m9RpSmd2GkLChLVQYr75p+AoSLA=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    ninja
  ];

  buildInputs = [
    libjpeg
    libpng
    libtiff
    qt1
    xorg.libX11
    xorg.libXext
    zlib
  ];

  # Lots of broken translation files.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(po)" "" \
      --replace-fail "CMAKE_ROOT}" "CMAKE_INSTALL_PREFIX}/share/cmake"
  '';

  postFixup = ''
    substituteInPlace $out/share/cmake/Modules/KDE1InstallDirs.cmake \
      --replace-fail '"${placeholder "out"}' '"''${CMAKE_INSTALL_PREFIX}'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "TIFF_LIBRARY" "tiff")
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-UNDEBUG"
    "-Wno-unused-result"
    "-Wno-nonnull"
  ];

  meta = {
    description = "Historical copy of the libraries module of KDE 1, adapted to compile on modern systems (circa. 2016";
    homepage = "https://invent.kde.org/historical/kde1-kdelibs";
    changelog = "https://invent.kde.org/historical/kde1-kdelibs/-/blob/${finalAttrs.src.rev}/ChangeLog";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
