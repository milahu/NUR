{ fetchFromGitHub
, lib
, makeBinaryWrapper
, nix-update-script
, stdenv
, versionCheckHook

  # Dependencies
, git
, gradle_8
, temurin-bin-17
}:

let
  inherit (lib) escapeShellArg versionAtLeast;
in
stdenv.mkDerivation (chunker: {
  pname = "chunker";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "HiveGamesOSS";
    repo = "Chunker";
    rev = "refs/tags/${chunker.version}";
    leaveDotGit = true;
    hash = "sha256-LK48fDR13XIiwMVd4Im0DivHOH2TaSzIUW3bXcIpnuc=";
  };

  mitmCache = gradle_8.fetchDeps {
    pkg = chunker.finalPackage;
    data = ./assets/chunker-deps.json; # To generate, run `$(path 'chunker.mitmCache.updateScript')`
  };

  nativeBuildInputs = [ git gradle_8 makeBinaryWrapper ];
  gradleFlags = [ "-Dorg.gradle.java.home=${temurin-bin-17}" ];

  installPhase = ''
    runHook preInstall

    jar="$out/share/chunker/chunker.jar"
    install -D 'build/libs/chunker-cli-'${escapeShellArg chunker.version}'.jar' "$jar"
    makeWrapper "${temurin-bin-17}/bin/java" "$out/bin/chunker" --add-flags "-jar $jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert Minecraft worlds between game versions";
    homepage = "https://www.chunker.app/";
    license = lib.licenses.mit;
    mainProgram = "chunker";
    broken = versionAtLeast lib.trivial.release "26.05"; # FIXME: Investigate build phase `java.lang.StackOverflowError`
  };
})
