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
    rev = "d21169382a02f2e4a622086f1ef56298fe094f02";
    hash = "sha256-2UkYz44btmhNjeLXnKWNY4U3eGQ6Iab26fBzugXf8Sg=";
  };
  pkg = callPackage "${src}/default.nix" { };
in
  pkg.overrideAttrs (base: {
    inherit src;
    pname = "uninsane-dot-org";
    version = "0-unstable-2026-02-08";
    passthru = (base.passthru or {}) // {
      updateScript = nix-update-script {
        extraArgs = [ "--version" "branch" ];
      };
    };
  })
