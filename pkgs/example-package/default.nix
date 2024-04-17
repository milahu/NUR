{ stdenv }:

stdenv.mkDerivation rec {

  pname = "example-package";
  version = "1.0";

  #src = ./.;
  dontUnpack = true;

  buildPhase = ''
    echo "echo Hello World" > example
  '';

  installPhase = ''
    install -Dm755 -t $out/bin example
  '';

}
