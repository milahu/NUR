{
  lib,
  rustPlatform,
  fetchFromGitea,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "magothy";
  version = "0-unstable-2025-07-11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "serebit";
    repo = "magothy";
    rev = "212c670f26bb948cb34604cf8c86d978f39134c2";
    hash = "sha256-66KKH4fnzkOVTZkO8f84Pf3TJN0aCILlNGn0e90NsVk=";
  };

  cargoHash = "sha256-7FlZZAO5YQI3WLONXIRjgBSgrdbq1DzGuHEcVpJaOLE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  # Does not have a proper version yet ("0.0.0").
  dontVersionCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "magothy";
    description = "A hardware profiling application for Linux";
    homepage = "https://codeberg.org/serebit/magothy";
    license = with lib.licenses; [
      asl20
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
