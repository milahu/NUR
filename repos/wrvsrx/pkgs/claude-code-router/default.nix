{
  stdenv,
  lib,
  nodejs,
  pnpm,
  makeWrapper,
  source,
}:
let
  ui = stdenv.mkDerivation (finalAttrs: {
    pname = source.pname + "-ui";
    inherit (source) version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    sourceRoot = "source/ui"; # Point to the ui subdirectory

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-D+rSbdikIqqZ3XfR25v5kD0HF+v09qafZYZibs/rdeA=";
      fetcherVersion = 2;
    };

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -m644 -D dist/index.html $out/index.html

      runHook postInstall
    '';
  });
in

stdenv.mkDerivation (finalAttrs: {
  inherit (source) pname src version;

  patches = [ ./ui-build.patch ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-bXEB2CVikCg7UGS8qaW1ItnU+kEm2y4xQCsnxNL5eOA=";
    fetcherVersion = 2;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build
    cp ${ui}/index.html dist/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules/$pname

    # Copy built files
    cp -r dist $out/lib/node_modules/$pname/dist
    makeWrapper ${lib.getExe nodejs} $out/bin/ccr \
      --add-flags $out/lib/node_modules/$pname/dist/cli.js

    runHook postInstall
  '';

  passthru = { inherit ui; };

  meta = {
    description = "Use Claude Code without an Anthropics account and route it to another LLM provider";
    homepage = "https://github.com/musistudio/claude-code-router";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.wrvsrx ];
    platforms = lib.platforms.all;
    mainProgram = "ccr";
  };
})
