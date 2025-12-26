{ fetchCrate
, lib
, nix-update-script
, rustPlatform
, versionCheckHook
}:

rustPlatform.buildRustPackage (oxvg: {
  pname = "oxvg";
  version = "0.0.5";

  src = fetchCrate {
    inherit (oxvg) pname version;
    sha256 = "sha256-I52L0cbj7BYdHVVhJEdhT28DRTg/f7eWpN0qGxfSdhQ=";
  };

  cargoHash = "sha256-+dfM2/SjUTwNAoKC7cjw2Ba1RNp6BwmbR1TxXtp9W4E=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust alternative to SVGO";
    homepage = "https://github.com/noahbald/oxvg";
    license = lib.licenses.mit;
    mainProgram = "oxvg";
  };
})
