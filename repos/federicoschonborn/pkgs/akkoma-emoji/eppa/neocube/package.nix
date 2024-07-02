{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "eppa-neocube";
  version = "0-unstable-2024-05-25";

  src = fetchzip {
    url = "https://hofnarretje.eu/assets/emoji/neocube.zip";
    hash = "sha256-8+0QVl+6zSZ98VixT1WP0XMZ7Cf55o42tZmG73RVqrg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';

  meta = {
    description = "A set of emojis featuring a familiar cube";
    homepage = "https://mooi.moe/emoji.html";
    license = lib.licenses.unfree; # TODO: ?
    platforms = lib.platforms.all;
    maintainers = [
      (lib.maintainers.federicoschonborn or {
        name = "Federico Damián Schonborn";
        email = "federicoschonborn@disroot.org";
        matrix = "FedericoDSchonborn:matrix.org";
        github = "FedericoSchonborn";
        githubId = 62166915;
      }
      )
    ];
  };
}
