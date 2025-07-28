{
  lib,
  stdenv,
  fetchFromGitLab,
  byacc,
  cmake,
  flex,
  ninja,
  pkg-config,
  libGL,
  libGLU,
  xorg,
  zlib,
}:

stdenv.mkDerivation {
  pname = "qt1";
  version = "0-unstable-2021-09-01";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "historical";
    repo = "qt1";
    rev = "25d30943816da9c28cded9ac7ce23b94c2ff2a5c";
    hash = "sha256-Ig5Qq3JbisGUlzlk/aG21E0i3yxTJwej5KIFFc58sL8=";
  };

  nativeBuildInputs = [
    byacc
    cmake
    flex
    ninja
    pkg-config
  ];

  buildInputs = [
    libGL
    libGLU
    xorg.libX11
    xorg.libXext
    xorg.libXmu
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "SYSTEM_ZLIB" true)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-unused-result"
    "-Wno-write-strings"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Historical copy of Qt 1, adapted to compile on modern systems";
    homepage = "https://invent.kde.org/historical/qt1";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
