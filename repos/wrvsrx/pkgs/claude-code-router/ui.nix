{
  stdenv,
  nodejs,
  pnpm,
  source,
}:
stdenv.mkDerivation (finalAttrs: {
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
})
