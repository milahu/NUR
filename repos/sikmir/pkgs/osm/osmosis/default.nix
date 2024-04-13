{ lib, stdenv, fetchfromgh, jre }:

stdenv.mkDerivation (finalAttrs: {
  pname = "osmosis";
  version = "0.48.3";

  src = fetchfromgh {
    owner = "openstreetmap";
    repo = "osmosis";
    name = "osmosis-${finalAttrs.version}.tgz";
    hash = "sha256-skxgFXjqTLDKiDAr5naP0GAr3obCVKDguQUTWB26Z/8=";
    inherit (finalAttrs) version;
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out
    cp -r . $out
    rm $out/bin/*.bat
    substituteInPlace $out/bin/osmosis \
      --replace-fail "JAVACMD=java" "JAVACMD=${jre}/bin/java"
  '';

  meta = with lib; {
    description = "Command line Java application for processing OSM data";
    homepage = "http://wiki.openstreetmap.org/wiki/Osmosis";
    license = licenses.gpl2;
    maintainers = [ maintainers.sikmir ];
    platforms = jre.meta.platforms;
  };
})
