{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderbird-gnome-theme";
  version = "115-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "thunderbird-gnome-theme";
    rev = "28e71ed964018ed5da2cc215e391901b68847c65";
    hash = "sha256-oqRbjHguuilu3wB8n05O0CBBfnEmKsT9+l9J4de48gU=";
  };

  installPhase = ''
    runHook preInstall

    cp -r $src $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A GNOME theme for Thunderbird";
    homepage = "https://github.com/rafaelmardojai/thunderbird-gnome-theme";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
