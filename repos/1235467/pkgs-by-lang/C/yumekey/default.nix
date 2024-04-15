{ lib
, stdenv
, fetchFromGitHub
, gcc
, cmake
, openssl
, bzip2
, libffi
, zlib
, wget
, pkgs
, ...
} @ args:
stdenv.mkDerivation rec {
  pname = "yumekey";
  version = "2.1.0";
  #doCheck = true;

  src = pkgs.fetchzip rec{
    url = "https://public.m5y6.c17.e2-5.dev/svkey-2.1.0.zip";
    sha256 = "sha256-dewWMgpgI+pYAh0c3X4fwTWpscMp66J9GMue6VEvOTk=";
  };
  #dontFixCmake = true;
  sourceRoot = "${src.name}/source";
  nativeBuildInputs = [ openssl bzip2 libffi zlib  cmake ];
#    buildPhase = ''
#    ls
#      ${pkgs.cmake}/bin/cmake .
#      '';
installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    cp svkey_artefacts/Release/svkey $out/bin/
    cp libsvpatch.so $out/lib
  '';
  BuildInputs = [ openssl bzip2 libffi zlib cmake ];

}
