{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "fotoente-neohaj";
  version = "0-unstable-2024-05-19";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fotoente";
    repo = "neohaj";
    rev = "ac1ecc95243d0ab1cbff9ed7ac1f6636ee239019";
    hash = "sha256-oneTxHooasdOHQIwEGp0e9YjHCLfDoyBXveIH212zLs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp high-res/png/*.png $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Source files for the neohaj emoji";
    homepage = "https://codeberg.org/fotoente/neohaj";
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
