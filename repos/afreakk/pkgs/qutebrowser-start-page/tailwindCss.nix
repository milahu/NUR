{ pkgs, src }:
pkgs.stdenv.mkDerivation {
  name = "qutebrowser-start-page-css";
  inherit src;
  buildPhase = ''
    ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i ./input.css -o ./output.css
  '';
  installPhase = ''
    mkdir -p $out/css
    cp output.css $out/css
  '';
}
