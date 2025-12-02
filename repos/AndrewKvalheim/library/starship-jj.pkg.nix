{ fetchCrate
, lib
, nix-update-script
, rustPlatform
, versionCheckHook
}:

rustPlatform.buildRustPackage (starship-jj: {
  pname = "starship-jj";
  version = "0.7.0";

  src = fetchCrate {
    inherit (starship-jj) pname version;
    sha256 = "sha256-oisz3V3UDHvmvbA7+t5j7waN9NykMUWGOpEB5EkmYew=";
  };

  cargoHash = "sha256-NNeovW27YSK/fO2DjAsJqBvebd43usCw7ni47cgTth8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Starship plugin for Jujutsu";
    homepage = "https://gitlab.com/lanastara_foss/starship-jj";
    license = lib.licenses.mit;
    mainProgram = "starship-jj";
  };
})
