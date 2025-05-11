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
  steam-run = (pkgs.steam.override {
    extraPkgs = p: (with pkgs; [ resource nss  ]);
    #runtimeOnly = true;
  }).run;
  startScript = pkgs.writeShellScript "cider" ''
    ${steam-run}/bin/steam-run \
      ${resource}/lib/cider/Cider --no-sandbox --disable-gpu-sandbox
  '';
  #libs = lib.makeLibraryPath  (with pkgs; [ dbus stdenv.cc.cc.lib glib nss]);
in

  
stdenv.mkDerivation {
  pname = "cider";
  version = "3.0.0";
  phases = [ "installPhase" ];
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ln -s ${startScript} $out/bin/cider
    cp -r ${resource}/share/* $out/share/
  '';
  #inherit libs;
  # installPhase = ''
  #     mkdir -p $out/lib 
  #     mkdir -p $out/bin
  #     mkdir -p $out/share
  #     cp -r ${resource}/lib/* $out/lib/
  #     echo "${pkgs.steam-run}/bin/steam-run $out/lib/cider/Cider" > $out/bin/cider
  #     cp -r ${resource}/share/* $out/share/
  #     chmod 755 -R $out
  # '';
}
