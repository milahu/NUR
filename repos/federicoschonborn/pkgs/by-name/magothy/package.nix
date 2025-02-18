{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "magothy";
  version = "0-unstable-2025-02-16";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "serebit";
    repo = "magothy";
    rev = "c9096d21ba476c2a658033275d0aae800264c1e3";
    hash = "sha256-aYlUkgUaC0uIV6ce5xkD3LfAZDnueXk4ZXuOMmqZ5N0=";
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
