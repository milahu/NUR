{ lib, stdenv, fetchurl, bash, jre_headless }:
let
  mcVersion = "1.18.2";
  buildNum = "225";
  jar = fetchurl {
     url = "https://papermc.io/api/v2/projects/paper/versions/${mcVersion}/builds/${buildNum}/downloads/paper-${mcVersion}-${buildNum}.jar";
     sha256 = "sha256-M9wsy2PxYa0g6Yae4xK4d4okPZIws3UZP5n/+Xam1qI=";
  };
in stdenv.mkDerivation {
  pname = "papermc";
  version = "${mcVersion}r${buildNum}";

  preferLocalBuild = true;

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cat > minecraft-server << EOF
    #!${bash}/bin/sh
    exec ${jre_headless}/bin/java \$@ -jar $out/share/papermc/papermc.jar nogui
  '';

  installPhase = ''
    install -Dm444 ${jar} $out/share/papermc/papermc.jar
    install -Dm555 -t $out/bin minecraft-server
  '';

  meta = with lib; {
    description = "High-performance Minecraft Server";
    homepage    = "https://papermc.io/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
  };
}