{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXft }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.8.2";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0ddz2mdp1c7q67rd5vrvws9r0493ln0mlqyc3d73dv8im884xdxf";
  };

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft ];

  patches = [./st-alpha-0.8.2.diff];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
