{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "magothy";
  version = "0-unstable-2025-02-22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "serebit";
    repo = "magothy";
    rev = "2e6fab393fc9f1cdb790c40f3ab5bfb1dc7661c0";
    hash = "sha256-2XJBrxWx4KZOYYsV+n/TJeqVHg+G+E5AXTADCTnLweQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LXlDv6gEY8HhyN7XNY9ioTD77o232yY3O/ZPjwBBKl4=";

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
