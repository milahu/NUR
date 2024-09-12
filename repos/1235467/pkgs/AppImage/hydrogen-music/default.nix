{ appimageTools, lib, fetchurl }:
appimageTools.wrapType2 rec {
  pname = "hydrogen-music";
  version = "0.5.0";
  name = "${pname}";

  src = fetchurl {
    url = "https://fly.storage.tigris.dev/public-hakutaku/Hydrogen.AppImage";
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
    license = licenses.mit;
  };
}
