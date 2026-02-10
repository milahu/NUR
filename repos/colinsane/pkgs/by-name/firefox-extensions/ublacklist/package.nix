{
  addon-git-updater,
  fetchurl,
  stdenv,
  unzip,
  wrapFirefoxAddonsHook,
  zip,
}:
stdenv.mkDerivation rec {
  pname = "ublacklist";
  version = "9.4.0";
  src = fetchurl {
    url = "https://github.com/iorate/ublacklist/releases/download/v${version}/ublacklist-v${version}-firefox.zip";
    hash = "sha256-n13M1mrOZqaeZKblkhv7aC6AdN557lQ+QWWNaX0DD+Y=";
  };
  # .zip file has everything in the top-level; stdenv needs it to be extracted into a subdir:
  sourceRoot = ".";
  preUnpack = ''
    mkdir src && cd src
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    zip -r -FS $out/$extid.xpi .
    runHook postInstall
  '';

  nativeBuildInputs = [
    unzip  # for unpackPhase
    wrapFirefoxAddonsHook
    zip
  ];

  extid = "@ublacklist";
  passthru.updateScript = addon-git-updater;
}
