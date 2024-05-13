{
  stdenv,
  sources,
  lib,
  makeWrapper,
  # Runtime dependnecies
  curl,
  inetutils,
  which,
  ...
}@args:
let
  additionalPath = lib.makeBinPath [
    curl
    inetutils
    which
  ];
in
stdenv.mkDerivation rec {
  pname = "dn42-pingfinder";
  version = "1.0.0";
  src = ./dn42-pingfinder.sh;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  installPhase = ''
    install -Dm755 $src $out/bin/dn42-pingfinder
    wrapProgram $out/bin/dn42-pingfinder \
      --suffix PATH : "${additionalPath}"
  '';

  meta = with lib; {
    description = "DN42 Pingfinder";
    homepage = "https://git.dn42.dev/dn42/pingfinder/src/branch/master/clients";
    license = licenses.unfreeRedistributable;
  };
}
