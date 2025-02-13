{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "chmod";
  version = "0-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "8945e543ebbaa25de155b7101a917eba007252f2";
    hash = "sha256-ko/vvItKtQSz5rbP3TMb4R1bywW2q8hj7E/A++vhVqQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    cp -r chmod.yazi $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Execute chmod on the selected files to change their mode";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/chmod.yazi";
    license = licenses.mit;
    maintainers = with maintainers; [ xyenon ];
  };
}
