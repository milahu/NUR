{ fetchFromGitea
, gitUpdater
, lib
, rustPlatform
, versionCheckHook

  # Dependencies
, cmake
, curl
, git
, libXcursor
, libXfixes
, libXinerama
, mesa
, pango
, pkg-config
}:

rustPlatform.buildRustPackage (pngquant-interactive: {
  pname = "pngquant-interactive";
  version = "0.2.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AndrewKvalheim";
    repo = "pngquant-interactive";
    rev = "refs/tags/v${pngquant-interactive.version}";
    hash = "sha256-LypGKz3YU8GqBKJOi0VuvqpplCrv8h3e3Oval1Q8WMs=";
  };

  cargoHash = "sha256-rnBknfO4+Y0GlHIysmiPz5Y2O5tByqdl6CBT7PC65fk=";

  nativeBuildInputs = [ cmake curl git pkg-config ];
  buildInputs = [ libXcursor libXfixes libXinerama mesa pango ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Graphical interface for pngquant with a live preview";
    homepage = "https://codeberg.org/AndrewKvalheim/pngquant-interactive";
    license = lib.licenses.gpl3;
    mainProgram = "pngquant-interactive";
  };
})
