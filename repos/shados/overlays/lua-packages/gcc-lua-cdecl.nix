{ lib, buildLuaPackage
, pkg-config, pins , gcc-lua
}:
buildLuaPackage rec {
  pname = "gcc-lua-cdecl";
  version = pins.${pname}.version;

  src = pins.${pname}.outPath;

  preBuild = ''
    set -x
  '';

  buildInputs = [
    gcc-lua
  ];

  buildFlags = [
    "GCCLUA=${gcc-lua}${gcc-lua.gccPluginPath}"
  ];

  meta = with lib; {
    description = "C declaration composer for the GNU Compiler Collection";
    homepage    = "https://git.colberg.org/peter/gcc-lua-cdecl";
    maintainers = [ maintainers.arobyn ];
    license     = licenses.mit;
  };
}
