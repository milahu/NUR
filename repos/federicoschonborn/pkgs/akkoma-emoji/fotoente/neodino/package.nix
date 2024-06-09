{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "fotoente-neodino";
  version = "0-unstable-2024-05-19";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fotoente";
    repo = "neodino";
    rev = "c625e202c38a3df196afd57608bdab7a14012e0f";
    hash = "sha256-bdQO7NZbAgf5LPi9H/9zdXeNx0TbaCdh7Ml5nChR8UM=";
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
    description = "Source files for the neodino emoji";
    homepage = "https://codeberg.org/fotoente/neodino";
    license = lib.licenses.unfree; # TODO: ?
    platforms = lib.platforms.all;
    # maintainers = [ lib.maintainers.federicoschonborn ];
  };
}
