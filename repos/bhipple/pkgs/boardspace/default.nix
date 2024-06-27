{ lib, stdenv, fetchurl, makeWrapper, openjdk }:

stdenv.mkDerivation rec {
  pname = "boardspace";
  version = "unstable-2024-06-26";

  src = fetchurl {
    url = "https://www.boardspace.net/java/jws/boardspace.jar";
    hash = "sha256-x0+1dL+iWlkJRg/kYO755quIAX61o1vtgt41nCyLFwc=";
  };

  buildInputs = [ makeWrapper openjdk ];

  buildCommand = ''
    mkdir $out
    makeWrapper ${openjdk}/bin/java $out/bin/boardspace --append-flags "-jar ${src}"
  '';

  meta = {
    homepage = "https://www.boardspace.net";
    description = "A place to play Board Games";
    #license = proprietary;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bhipple ];
  };
}
