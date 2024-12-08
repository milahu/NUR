{ lib, stdenv
, pkg-config, pins
, gmp, lua, gcc
}:
let
  gccPluginPath = "/lib/gcc/${stdenv.targetPlatform.config}/${gcc.cc.version}/plugin";
in stdenv.mkDerivation rec {
  pname = "gcc-lua";
  version = pins.${pname}.version;

  src = pins.${pname}.outPath;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gmp lua gcc
  ];

  preInstall = ''
    set -x
  '';
  installFlags = [
    "DESTDIR=$(out)"
    "INSTALL_GCC_PLUGIN=${gccPluginPath}"
  ];

  passthru = {
    gccPluginPath = "${gccPluginPath}/gcclua.so";
  };

  meta = with lib; {
    description = "Extends the GNU Compiler Collection with the ability to run Lua scripts";
    homepage    = https://peter.colberg.org/gcc-lua;
    maintainers = with maintainers; [ arobyn ];
    platforms   =  [ "x86_64-linux" ];
    license     = licenses.mit;
  };
}
