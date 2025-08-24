{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "thunderbird-gnome-theme";
  version = "115-unstable-2025-08-22";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "thunderbird-gnome-theme";
    rev = "b1fbb41db5718c23667bd9b40268b8e7317634fd";
    hash = "sha256-oLmw1VRrmbuLwT5errG3lT85K0jLII/aQ32VtdJ+1xM=";
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
