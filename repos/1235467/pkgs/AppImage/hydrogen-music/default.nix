{ appimageTools, lib, fetchurl }:
appimageTools.wrapType2 rec {
  pname = "hydrogen-music";
  version = "0.5.0";
  name = "${pname}";

  src = fetchurl {
    url = "https://m5y6.c17.e2-5.dev/hydrogen/Hydrogen.AppImage";
    sha256 = "sha256-wB14EMoB9pd/aPLO1ntU2qZvqlmwS2qqK1s0wd81xyU=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit name src; };
    in
    ''
      cp -r ${contents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "Hydrogen Music";
    platforms = [ "x86_64-linux" ];
  };
}
