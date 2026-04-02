{ fetchFromGitea
, gitUpdater
, lib
, rustPlatform
, versionCheckHook

  # Dependencies
, cmake
}:

rustPlatform.buildRustPackage (little-a-map: {
  pname = "little-a-map";
  version = "0.13.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AndrewKvalheim";
    repo = "little-a-map";
    rev = "refs/tags/v${little-a-map.version}";
    hash = "sha256-KIQDOkJBz9c4quqe17NEVNVUgQIUKq1Ap7jPr3HpVQs=";
  };

  cargoHash = "sha256-E7p5Ahc2ViUDr5hSYLrh8zRh/u3YrA51nVTALWYKnZI=";

  nativeBuildInputs = [ cmake ];

  preCheck = ''
    export TEST_OUTPUT_PATH="$TMPDIR"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Compositor of player-created Minecraft map items";
    homepage = "https://codeberg.org/AndrewKvalheim/little-a-map";
    license = lib.licenses.gpl3;
    mainProgram = "little-a-map";
  };
})
