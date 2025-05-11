{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, pkgs
, ...
} @ args:

let
  src = fetchurl {
    url = "https://repo.cider.sh/arch/cider-v3.0.0-linux-x64.pkg.tar.zst";
    sha256 = "sha256-+Rdak70dPmL/+DV5LhEY94ypEUz9FhxhOwVQ2V2Q/Xg=";
  };
  resource = stdenv.mkDerivation rec {
    name = "cider-pkg";
    unpackPhase = ''
      ${pkgs.gnutar}/bin/tar --zstd -xvf ${src}
    '';
    nativeBuildInputs = [ pkgs.zstd ];
    installPhase = ''
      mkdir -p $out
      cp -r ./usr/* $out/
    '';

  };
  #libs = lib.makeLibraryPath  (with pkgs; [ dbus stdenv.cc.cc.lib glib nss]);
in
stdenv.mkDerivation {
  pname = "cider";
  version = "3.0.0";
  phases = [ "installPhase" ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  #inherit libs;
  installPhase = ''
      mkdir -p $out/lib 
      mkdir -p $out/bin
      mkdir -p $out/share
      cp -r ${resource}/lib/* $out/lib/
      echo "$out/lib/cider/Cider --no-sandbox --disable-gpu-sandbox" > $out/bin/cider
      cp -r ${resource}/share/* $out/share/
      chmod 755 -R $out
      autoPatchelf $out/lib/cider/Cider
  '';
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    dbus
    nss
    glib
    xcbutilxrm
    gtk3
    xorg.libX11
    nwjs
  ];
}
