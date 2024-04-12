{ lib, stdenv, pkg-config, libgnome-keyring }:

stdenv.mkDerivation {
  name = "lock-gnome-keyring";

  buildInputs = [ libgnome-keyring ];
  nativeBuildInputs = [ pkg-config ];

  src = ./src;

  installPhase = ''
    mkdir -p $out/bin
    mv main $out/bin/lock-gnome-keyring
  '';

  meta = with lib; {
    description = "Locks the gnome-keyring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
