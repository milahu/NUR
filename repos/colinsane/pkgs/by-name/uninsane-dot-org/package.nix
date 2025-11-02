{
  callPackage,
  fetchFromGitea,
  nix-update-script,
}:
let
  src = fetchFromGitea {
    domain = "git.uninsane.org";
    owner = "colin";
    repo = "uninsane";
    rev = "23b4cfde0c2f5842ff9dcabe854eb5a5b7ddccb1";
    hash = "sha256-l+l9n/sT6ybEoSWWaQBhNYynjC/R6yywVgxACQhYOMM=";
  };
  pkg = callPackage "${src}/default.nix" { };
in
  pkg.overrideAttrs (base: {
    inherit src;
    pname = "uninsane-dot-org";
    version = "0-unstable-2025-06-23";
    passthru = (base.passthru or {}) // {
      updateScript = nix-update-script {
        extraArgs = [ "--version" "branch" ];
      };
    };
  })
