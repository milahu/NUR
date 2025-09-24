{ pkgs
, lib
,
}:
let
  sources = {
    x86_64.url = "https://downloads.cursor.com/production/b753cece5c67c47cb5637199a5a5de2b7100c18f/linux/x64/Cursor-1.6.35-x86_64.AppImage";
    x86_64.hash = "sha256-62u8snx9nbJtsg7uROZNVzo3macrkTghTCep943e8+I=";
  };
in
pkgs.appimageTools.wrapType2 {
  pname = "cursor";
  version = "1.6.35";
  src =
    pkgs.fetchurl
      (
        if pkgs.stdenv.isx86_64
        then sources.x86_64
        else "Unsupported architecture for Cursor editor"
      );
  meta = {
    description = "AI-first code editor built on VS Code, designed to enhance productivity through AI-assisted coding";
    longDescription = ''
      Cursor is an AI-powered code editor that extends VS Code's functionality with advanced AI capabilities,
      such as AI-assisted code completion and refactoring, natural language command processing.
    '';
    homepage = "https://cursor.com";
    downloadPage = "https://cursor.com/download";
    changelog = "https://github.com/getcursor/cursor/releases";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.kugland ];
    mainProgram = "cursor";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
