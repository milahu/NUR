{ fetchCrate
, lib
, nix-update-script
, rustPlatform
, versionCheckHook
}:

rustPlatform.buildRustPackage (starship-jj: {
  pname = "starship-jj";
  version = "0.5.1";

  src = fetchCrate {
    inherit (starship-jj) pname version;
    sha256 = "sha256-tQEEsjKXhWt52ZiickDA/CYL+1lDtosLYyUcpSQ+wMo=";
  };

  cargoHash = "sha256-+rLejMMWJyzoKcjO7hcZEDHz5IzKeAGk1NinyJon4PY=";

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
