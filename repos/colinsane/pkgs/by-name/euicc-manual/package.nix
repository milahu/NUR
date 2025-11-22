# notably, euicc-manual provides $out/share/doc/euicc-manual/docs/pkg/ci/manifest.json
# and $out/share/doc/euicc-manual/docs/pki/eum/manifest.json
# which are used by lpac
{
  fetchgit,
  fetchFromGitea,
  hugo,
  lib,
  stdenvNoCC,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "euicc-manual";
  version = "0-unstable-2025-11-21";

  # XXX: their gitea downloads are broken, so use fetchgit
  src = fetchgit {
    url = "https://gitea.osmocom.org/sim-card/euicc-manual";
    rev = "2f9be0aa4e41e8f1b95b5cccef47e461bd674adb";
    hash = "sha256-lHD/E9+uArZggh/eQCvtXbSrwtCg0aMyW/P8yn7blhE=";
  };

  nativeBuildInputs = [
    hugo
  ];

  buildPhase = ''
    runHook preBuild

    hugo

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/
    cp -Rv public $out/share/doc/euicc-manual

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
    ci_manifest = "${finalAttrs.finalPackage}/share/doc/euicc-manual/docs/pki/ci/manifest.json";
    eum_manifest = "${finalAttrs.finalPackage}/share/doc/euicc-manual/docs/pki/eum/manifest-v2.json";
  };

  meta = with lib; {
    description = "Osmocom eUICC and eSIM Developer Manual";
    homepage = "https://euicc-manual.osmocom.org";
    repo = "https://gitea.osmocom.org/sim-card/euicc-manual";
    maintainers = with maintainers; [ colinsane ];
  };
})
