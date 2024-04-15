{ stdenv
, fetchFromGitHub
, lib
, asciidoc
, flac
, bash
, makeWrapper
, callPackage
, ...
}:
let
  pname = "reflac";
  sources = callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  inherit pname;
  inherit (sources.reflac) version src;

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    asciidoc
    flac
    bash
  ];

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp reflac $out/bin
    wrapProgram $out/bin/reflac \
        --prefix PATH : ${lib.makeBinPath [ asciidoc flac bash]}
  '';

  meta = with lib; {
    description = "Shell script to recompress FLAC files";
    homepage = "https://github.com/chungy/reflac";
    maintainers = [ ];
  };
}
