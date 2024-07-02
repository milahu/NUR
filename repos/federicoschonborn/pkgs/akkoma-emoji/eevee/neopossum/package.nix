{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "eevee-neopossum";
  version = "0-unstable-2024-03-04";

  src = fetchzip {
    url = "https://skunks.gay/download/neopossum-256px_v0.5.zip";
    hash = "sha256-md1CKmw+UroixUdW+AceXdGQmzcwT+KkZt3AnYx/xFw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png $out

    runHook postInstall
  '';

  meta = {
    description = "A set of emojis featuring a bun";
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
