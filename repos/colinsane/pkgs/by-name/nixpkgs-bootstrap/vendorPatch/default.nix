{ stdenv }:
name: stdenv.mkDerivation {
  inherit name;
  src = ../patches/${name}.patch;
  dontUnpack = true;
  installPhase = ''
    ln -s "$src" "$out"
  '';
  dontFixup = true;
}
