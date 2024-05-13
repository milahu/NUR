{
  stdenv,
  sources,
  lib,
  ncurses,
  ...
}@args:
stdenv.mkDerivation rec {
  inherit (sources.gopherus) pname version src;

  buildInputs = [ ncurses ];

  buildPhase = ''
    make -f Makefile.lin gopherus
  '';

  installPhase = ''
    install -Dm755 gopherus $out/bin/gopherus
  '';

  meta = with lib; {
    description = "Gopherus is a free, multiplatform, console-mode gopher client that provides a classic text interface to the gopherspace.";
    homepage = "http://gopherus.sourceforge.net/";
    license = with licenses; [ bsd2 ];
  };
}
