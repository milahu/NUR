{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderbird-gnome-theme";
  version = "115-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "thunderbird-gnome-theme";
    rev = "a9ee1a2c8a1dfce700250a4ce3ce7f88dff43300";
    hash = "sha256-zADBsXqIkxy519sK/2mnZ/lcTQSA/3iXwdkXCVNqUVY=";
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
