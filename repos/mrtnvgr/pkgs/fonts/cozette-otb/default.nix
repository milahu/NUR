{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cozette";
  version = "1.22.2";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts-v-${builtins.replaceStrings ["."] ["-"] version}.zip";
    hash = "sha256-Y6StCbAsFJrRZtJu1IAsMYuyNhwe3YIlT41EhSXhCUE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otb -t $out/share/fonts/misc

    runHook postInstall
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
    changelog = "https://github.com/slavfox/Cozette/blob/v.${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
