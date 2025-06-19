{
  stdenv,
  fetchurl,
  p7zip,
  libarchive,
  lib,
}:

stdenv.mkDerivation rec {
  name = "sf-mono";
  version = "14.0.0";
  src = fetchurl {
    url = "https://developer.apple.com/design/downloads/SF-Mono.dmg";
    hash = "sha256-bUoLeOOqzQb5E/ZCzq0cfbSvNO1IhW1xcaLgtV2aeUU=";
  };

  nativeBuildInputs = [
    p7zip
    libarchive
  ];

  unpackPhase = ''
    mkdir -p $TMPDIR/SF-Mono-${version}
    cd $TMPDIR/SF-Mono-${version}
    7z x $src
    bsdtar xvPf "SFMonoFonts/SF Mono Fonts.pkg"
    bsdtar xvPf "SFMonoFonts.pkg/Payload"
  '';
  installPhase = ''
    runHook preInstall
    cd $TMPDIR/SF-Mono-${version}
    find ./Library/Fonts -name '*.otf' -exec install -Dt $out/share/fonts/opentype {} \;
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://developer.apple.com/fonts/";
    description = "Apple's SF Mono Font";
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
