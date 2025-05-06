{
  lib,
  budgie-desktop,
  gtk-layer-shell,
  nix-update-script,
  xfce,
  ...
}:

budgie-desktop.overrideAttrs (prevAttrs: {
  version = "10.9.2-unstable-2025-05-05";

  src = prevAttrs.src.override {
    rev = "830d722c6997fbcfd5cb6c675f9f620936efaf35";
    hash = "sha256-wOm8uCyjup7e9hiq6rJSSDPIi7GVSJPOyB5TfNGhyao=";
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
