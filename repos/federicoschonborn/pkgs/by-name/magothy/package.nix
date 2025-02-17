{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "magothy";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "serebit";
    repo = "magothy";
    rev = "673efc8af910908269dccd5e5804090b042308d4";
    hash = "sha256-spAIROtCkjgM5wyM02Ptn6WZs6krW8xhiSL3qjGynUs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vsHxpcFMpgF7fzVdvK5X+ET7bxFNrNtfNTdhOyPMF8Q=";

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
