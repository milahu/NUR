{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "fg";
  version = "0-unstable-2025-02-08";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "fg.yazi";
    rev = "daf696065d65e61a1b3026ab8190351203513d51";
    hash = "sha256-dcidPBhc0+NvPb80hK+kUoq+PxspceFCliyEc7K3OTk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Yazi plugin for rg search with fzf file preview";
    homepage = "https://github.com/DreamMaoMao/fg.yazi";
    license = licenses.mit;
    maintainers = with maintainers; [ xyenon ];
  };
}
