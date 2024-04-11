{
  sources,
  stdenvNoCC,
  lib,
  jre_headless,
  makeWrapper,
  unzip,
  ...
}@args:
stdenvNoCC.mkDerivation rec {
  inherit (sources.jproxy) pname version src;

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    mkdir -p $out/bin $out/opt
    cp -r * $out/opt/

    makeWrapper ${jre_headless}/bin/java $out/bin/jproxy \
      --add-flags "-Xms512m" \
      --add-flags "-Xmx512m" \
      --add-flags "-Dfile.encoding=utf-8" \
      --add-flags "-jar" \
      --add-flags "$out/opt/jproxy.jar" \
  '';

  meta = with lib; {
    description = "A proxy between Sonarr / Radarr and Jackett / Prowlarr, mainly used to optimize search and improve recognition rate ";
    homepage = "https://github.com/LuckyPuppy514/jproxy";
    license = licenses.mit;
  };
}
