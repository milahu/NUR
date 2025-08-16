{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nesfab";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "pubby";
    repo = "nesfab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jwqstyRr79Yl1vRoSiNCFAOkWjAXieEH/pzJHcmaLMo=";
  };

  buildInputs = [
    boost
  ];

  strictDeps = true;

  makeFlags = [
    "release"
    "GIT_COMMIT=${finalAttrs.src.tag}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp nesfab $out/bin/nesfab

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "nesfab";
    description = "Programming language that targets the Nintendo Entertainment System";
    homepage = "https://github.com/pubby/nesfab";
    changelog = "https://github.com/pubby/nesfab/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
