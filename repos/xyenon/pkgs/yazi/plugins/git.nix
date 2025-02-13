{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "git";
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

    cp -r git.yazi $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Show the status of Git file changes as linemode in the file list";
    homepage = "https://github.com/yazi-rs/plugins/tree/main/git.yazi";
    license = licenses.mit;
    maintainers = with maintainers; [ xyenon ];
  };
}
