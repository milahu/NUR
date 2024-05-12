{ lib
, stdenv
, fetchFromGitHub
, cmake
, desktopToDarwinBundle
, wrapQtAppsHook
, qtsvg
, qtwebsockets
, qtx11extras
, mosquitto
, libdwarf
, protobuf
, zeromq
, zstd
}:

stdenv.mkDerivation rec {
  pname = "plotjuggler";
  version = "3.9.2";

  src = fetchFromGitHub {
    owner = "facontidavide";
    repo = "PlotJuggler";
    rev = version;
    hash = "sha256-Dl2vE4iGhcGLH5lf1eCdybhfTG1bgI0Skw+AHKdvolQ=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(PJ_PLUGIN_INSTALL_DIRECTORY bin)" "set(PJ_PLUGIN_INSTALL_DIRECTORY lib/plugins)"
    substituteInPlace plotjuggler_app/mainwindow.cpp \
      --replace-fail "QCoreApplication::applicationDirPath()" "\"$out/lib/plugins\""
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ]
    ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [ qtsvg qtwebsockets mosquitto libdwarf protobuf zeromq zstd ]
    ++ lib.optionals stdenv.isLinux [ qtx11extras ];

  meta = with lib; {
    description = "The Time Series Visualization Tool";
    homepage = "https://www.plotjuggler.io/";
    license = licenses.mpl20;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
}