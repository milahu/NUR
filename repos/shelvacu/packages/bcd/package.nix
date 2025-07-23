{
  lib,
  jdk,
  gradle_7,

  makeWrapper,
  stdenv,
  fetchFromGitLab,
}:
let
  gradle = gradle_7;
  self = stdenv.mkDerivation rec {
    pname = "bandcamp-collection-downloader";
    version = "v2021-12-05";

    nativeBuildInputs = [
      gradle
      makeWrapper
    ];

    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "Ezwen";
      repo = "bandcamp-collection-downloader";
      rev = version;
      hash = "sha256-uvfpTFt92mp4msm06Y/1Ynwx6+DiE+bR8O2dntTzj9I=";
    };

    mitmCache = gradle.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    # tests want to talk to bandcamp
    doCheck = false;

    gradleBuildTask = "fatjar";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/{bin,share/java/bandcamp-collection-downloader}
      cp build/libs/bandcamp-collection-downloader.jar "$out"/share/java/bandcamp-collection-downloader/bandcamp-collection-downloader.jar

      makeWrapper ${lib.getExe jdk} "$out"/bin/bandcamp-collection-downloader \
        --add-flags "-jar $out/share/java/bandcamp-collection-downloader/bandcamp-collection-downloader.jar"

      runHook postInstall
    '';

    meta = {
      description = "CLI for downloading purchased music from bandcamp";
      homepage = "https://framagit.org/Ezwen/bandcamp-collection-downloader";
      license = [ lib.licenses.agpl3Only ];
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        # because of how dependencies are currently handled with the mitm cache
        binaryNativeCode
        binaryBytecode
      ];
      mainProgram = "bandcamp-collection-downloader";
      platforms = lib.platforms.all;
    };
  };
in
self
