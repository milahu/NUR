{ lib, bitwarden-cli, coreutils, jq, keyutils, makeWrapper, rofi, stdenvNoCC }:
stdenvNoCC.mkDerivation rec {
  pname = "bw-pass";
  version = "0.1.0";

  src = ./bw-pass;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/${pname}
    chmod a+x $out/bin/${pname}
  '';

  wrapperPath = lib.makeBinPath [
    bitwarden-cli
    coreutils
    jq
    keyutils
    rofi
  ];

  fixupPhase = ''
    patchShebangs $out/bin/${pname}
    wrapProgram $out/bin/${pname} --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib; {
    description = "A simple script to query a password from bitwarden";
    homepage = "https://git.belanyi.fr/ambroisie/nix-config";
    license = with licenses; [ mit ];
    mainProgram = "bw-pass";
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.linux;
  };
}
