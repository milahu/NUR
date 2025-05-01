{
  lib,
  budgie-desktop,
  gtk-layer-shell,
  nix-update-script,
  xfce,
  ...
}:

budgie-desktop.overrideAttrs (prevAttrs: {
  version = "10.9.2-unstable-2025-04-29";

  src = prevAttrs.src.override {
    rev = "dda1fd7a0db196f0dc78913f5977a46ccb7ed2c3";
    hash = "sha256-Q3IR+hEc5Wucp+tb/jZBqgOHbju87k9cHr4lmmxL034=";
  };

  patches = [ ];

  buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
    gtk-layer-shell
  ];

  mesonFlags = (prevAttrs.mesonFlags or [ ]) ++ [
    # Don't check for runtime dependencies to avoid bloating up the derivation.
    (lib.mesonBool "with-runtime-dependencies" false)
  ];

  passthru = (prevAttrs.passthru or { }) // {
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "branch"
      ];
    };
  };

  meta = (prevAttrs.meta or { }) // {
    broken = lib.versionOlder xfce.libxfce4windowing.version "4.19.7";
  };
})
