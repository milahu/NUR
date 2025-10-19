{ pkgs
, lib
, appimageTools
}:
let
  sources = {
    x86_64.url = "https://github.com/musescore/MuseScore/releases/download/v4.6.2/MuseScore-Studio-4.6.2.252830930-x86_64.AppImage";
    x86_64.hash = "sha256-GAJmPhpxnVTKFU8KCIZfyFZCy5ic1/ZLLkjvgQAKO2E=";
    aarch64.url = "https://github.com/musescore/MuseScore/releases/download/v4.6.2/MuseScore-Studio-4.6.2.252830930-aarch64.AppImage";
    aarch64.hash = "sha256-YUDfXVBhq2oZgYwlsLsRuuR/Wjpq0V/ifcUSPNv9Td4=";
  };
in
appimageTools.wrapType2 {
  pname = "musescore";
  version = "4.6.2.252830930";
  src =
    pkgs.fetchurl
      (
        if pkgs.stdenv.hostPlatform.isx86_64
        then sources.x86_64
        else if pkgs.stdenv.hostPlatform.isAarch64
        then sources.aarch64
        else "Unsupported architecture for MuseScore"
      );
  meta = {
    description = "Free and open-source music notation software for creating, playing and printing sheet music";
    longDescription = ''
      MuseScore is a free and open-source music notation software that allows users to create,
      play and print sheet music. It features a WYSIWYG editor with unlimited score size,
      unlimited number of staves, and support for up to four voices per staff.
    '';
    homepage = "https://musescore.org";
    downloadPage = "https://musescore.org/download";
    changelog = "https://github.com/musescore/MuseScore/releases";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    maintainers = [ lib.maintainers.kugland ];
    mainProgram = "musescore";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
