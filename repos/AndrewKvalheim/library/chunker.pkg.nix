{ fetchFromGitHub
, lib
, makeBinaryWrapper
, nix-update-script
, stdenv
, versionCheckHook

  # Dependencies
, git
, gradle_9
, temurin-bin-17
}:

let
  inherit (builtins) match;
  inherit (lib) concatStrings escapeShellArg licenses;
in
stdenv.mkDerivation (chunker: {
  pname = "chunker";
  version = "1.16.0";
  meta = {
    description = "Convert Minecraft worlds between game versions";
    homepage = "https://www.chunker.app/";
    license = licenses.mit;
    mainProgram = "chunker";
  };

  passthru.updateScript = nix-update-script { };

  src = fetchFromGitHub {
    owner = "HiveGamesOSS";
    repo = "Chunker";
    rev = "refs/tags/${chunker.version}";
    leaveDotGit = true;
    hash = "sha256-cEOw56f8wKnaXkjY21tJnTboIyNn1I6K3PuyjDN4SWo=";
  };

  mitmCache =
    let tag = "gradle${concatStrings (match "([[:digit:]]+)\\.([[:digit:]]+).*" gradle_9.version)}"; in
    gradle_9.fetchDeps {
      pkg = chunker.finalPackage;
      data = ./assets/chunker-deps-${tag}.json; # To generate, run `$(nix-build --pure '<nixpkgs>' --attr 'chunker.mitmCache.updateScript')`
    };

  nativeBuildInputs = [ git gradle_9 makeBinaryWrapper ];
  gradleFlags = [ "-Dorg.gradle.java.home=${temurin-bin-17}" ];

  installPhase = ''
    runHook preInstall

    jar="$out/share/chunker/chunker.jar"
    install -D 'build/libs/chunker-cli-'${escapeShellArg chunker.version}'.jar' "$jar"
    makeWrapper "${temurin-bin-17}/bin/java" "$out/bin/chunker" --add-flags "-jar $jar"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
})
