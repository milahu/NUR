{ lib, stdenvNoCC, fetchurl, _7zz }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zed";
  version = "0.132.5";

  src = fetchurl {
    url = "https://zed.dev/api/releases/stable/${finalAttrs.version}/Zed.dmg";
    hash = "sha256-6k40weWeCG8OdGynGeQgraHKtBzPHZ88Hu+ScLa7ngM=";
  };

  sourceRoot = ".";

  # APFS format is unsupported by undmg
  nativeBuildInputs = [ _7zz ];
  unpackCmd = "7zz x $curSrc";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications,bin}
    cp -r *.app $out/Applications
    ln -s $out/Applications/Zed.app/Contents/MacOS/cli $out/bin/zed
    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance, multiplayer code editor";
    homepage = "https://zed.dev";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.free;
    maintainers = [ maintainers.sikmir ];
    platforms = [ "x86_64-darwin" ];
    skip.ci = true;
  };
})
