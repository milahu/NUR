{
  stdenv,
  lib,
  nodejs,
  pnpm,
  makeWrapper,
  source,
}:
let
  ui = import ./ui.nix {
    inherit
      stdenv
      nodejs
      pnpm
      source
      ;
  };
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
    hash = "sha256-j4dlv5hWErJugQWXR98XsGgD0LSkJhocAz35M0Bymp4=";
    fetcherVersion = 2;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/node_modules/$pname

    # Copy built files
    cp -r dist $out/lib/node_modules/$pname/dist
    ln -s ${ui}/index.html $out/lib/node_modules/$pname/dist/
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
