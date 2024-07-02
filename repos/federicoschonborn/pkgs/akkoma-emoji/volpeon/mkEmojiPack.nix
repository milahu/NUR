{
  lib,
  stdenvNoCC,
  fetchzip,
}:

{
  name,
  version,
  hash,
}:

stdenvNoCC.mkDerivation {
  pname = "volpeon-${name}";
  inherit version;

  src = fetchzip {
    url = "https://volpeon.ink/emojis/${name}/${name}.zip";
    inherit hash;
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp *.png LICENSE $out

    runHook postInstall
  '';

  meta = {
    description = "${name} emoji pack";
    homepage = "https://volpeon.ink/emojis/${name}/";
    license = lib.licenses.cc-by-nc-sa-40;
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
