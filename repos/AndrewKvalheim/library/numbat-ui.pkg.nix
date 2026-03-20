{ fetchFromGitHub
, fetchNpmDeps
, lib
, nix-update-script
, npmHooks
, rustPlatform
, wrapGAppsHook4

  # Dependencies
, cargo-tauri
, nodejs
, pkg-config
, webkitgtk_4_1
}:

rustPlatform.buildRustPackage (numbat-ui: {
  pname = "numbat-ui";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fabiomanz";
    repo = "numbat-ui";
    rev = "refs/tags/v${numbat-ui.version}";
    hash = "sha256-ZxGiPlefT6e7puiR3YlmVznwqX7YX0UqirkocygRzqs=";
  };

  cargoPatches = [ ./assets/numbat-ui_create-cargo-lock.patch ];
  cargoRoot = "src-tauri";
  cargoHash = "sha256-k53w6PKYXA6E68cFl1Rk6tUGocSyEas+nXiUed+Loj0=";
  buildAndTestSubdir = numbat-ui.cargoRoot;

  npmDeps = fetchNpmDeps {
    inherit (numbat-ui) src;
    hash = "sha256-/Nteh0X80HGjHabDAo2KcPGbL3aGs4JklaxX0fKkLxQ=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    webkitgtk_4_1
  ];

  checkFlags = [
    "--skip=test_numbat_version" # Maintainer script, requires internet access
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native GUI for the Numbat scientific calculator";
    homepage = "https://github.com/fabiomanz/numbat-ui";
    license = lib.licenses.mit;
    mainProgram = "numbat-ui";
  };
})
