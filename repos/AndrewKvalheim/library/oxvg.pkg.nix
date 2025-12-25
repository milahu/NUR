{ fetchCrate
, lib
, nix-update-script
, rustPlatform
, versionCheckHook
}:

rustPlatform.buildRustPackage (oxvg: {
  pname = "oxvg";
  version = "0.0.3";

  src = fetchCrate {
    inherit (oxvg) pname version;
    sha256 = "sha256-mSuOqcveJ6GY0xsRlV+zhUqBtvOT7PbMZWTioBSV+J0=";
  };

  cargoHash = "sha256-K4F2NvRl+05Ex7vDiUSzmYdezL+BcSaksTlpUrHbT7o=";

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
