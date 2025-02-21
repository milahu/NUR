{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "magothy";
  version = "0-unstable-2025-02-19";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "serebit";
    repo = "magothy";
    rev = "1a8a1227aebac9293232ab3bf5c9ef24c619266c";
    hash = "sha256-Ya85uDTmshmJtQbumbNOFkDH3NRLfvd/gyzdvZWGtiE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YFM0rZmio727AHyRlW2BHpFDHFRZhYrWX+lvRpldzJY=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

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
