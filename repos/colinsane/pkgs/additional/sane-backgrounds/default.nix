{ stdenv
, inkscape
}:
stdenv.mkDerivation {
  pname = "sane-backgrounds";
  version = "0.3";

  src = ./.;

  nativeBuildInputs = [ inkscape ];

  buildPhase = ''
    inkscape sane-nixos-bg.svg -o sane-nixos-bg.png
  '';

  installPhase = ''
    mkdir -p $out/share/backgrounds
    cp *.svg *.png $out/share/backgrounds
  '';
}
