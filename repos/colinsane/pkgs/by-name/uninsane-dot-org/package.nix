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
    rev = "b5434293f0c983db7e269064f16758c546c24e6a";
    hash = "sha256-WmU770kjQ9sbG/vYrzqPCBGE2fIvJatOFpYvTDXmh64=";
  };
  pkg = callPackage "${src}/default.nix" { };
in
  pkg.overrideAttrs (base: {
    inherit src;
    pname = "uninsane-dot-org";
    version = "0-unstable-2026-01-17";
    passthru = (base.passthru or {}) // {
      updateScript = nix-update-script {
        extraArgs = [ "--version" "branch" ];
      };
    };
  })
