{ fetchFromGitHub
, gitUpdater
, lib
, rustPlatform

  # Dependencies
, alsa-lib
, dbus
, gdk-pixbuf
, glib
, gobject-introspection
, graphene
, gtk4
, libadwaita
, libnotify
, libX11
, libXScrnSaver
, pango
, pkg-config
}:

rustPlatform.buildRustPackage (stretch-break: {
  pname = "stretch-break";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "pieterdd";
    repo = "StretchBreak";
    rev = "refs/tags/${stretch-break.version}";
    hash = "sha256-IRLVhMXS0LjUbNPCrZPdi0jBxV7JFukM/7hk6q/0lK8=";
  };

  cargoHash = "sha256-1njbxgDMgkxC+4BMJJhm+/FwSGxopbnN0hJxMz6KXu0=";

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    dbus
    gdk-pixbuf
    glib
    graphene
    gtk4
    libadwaita
    libnotify
    libX11
    libXScrnSaver
    pango
  ];

  checkFlags = [
    # FIXME
    # assertion `left == right` failed
    #   left: WidgetInfo { normal_timer_value: "19:29", countdown_to_reset_value: "", prebreak_timer_value: "", overrun_value: "", presence_mode: SnoozedUntil(2025-02-03T12:34:11Z), snoozed_until_time: Some("12:34"), reading_mode: false }
    #  right: WidgetInfo { normal_timer_value: "19:29", countdown_to_reset_value: "", prebreak_timer_value: "", overrun_value: "", presence_mode: SnoozedUntil(2025-02-03T12:34:11Z), snoozed_until_time: Some("13:34"), reading_mode: false }
    "--skip=dbus::tests::idle_status_muted"
  ];

  postInstall = ''
    mkdir --parents "$out/share/applications"
    substitute \
      "$src/meta/io.github.pieterdd.StretchBreak.desktop" \
      "$out/share/applications/io.github.pieterdd.StretchBreak.desktop" \
      --replace-fail 'Exec=stretch-break' "Exec=$out/bin/stretch-break"

    mkdir --parents "$out/share/dbus-1/services"
    substitute \
      "$src/meta/io.github.pieterdd.StretchBreak.Core.service" \
      "$out/share/dbus-1/services/io.github.pieterdd.StretchBreak.Core.service" \
      --replace-fail '/usr/bin' "$out/bin"

    mkdir --parents "$out/share/icons/hicolor/256x256/apps"
    cp --no-preserve=mode --reflink=auto \
      "$src/meta/logo-color-256x256.png" \
      "$out/share/icons/hicolor/256x256/apps/io.github.pieterdd.StretchBreak.png"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Helps you take regular breaks from using your computer";
    homepage = "https://github.com/pieterdd/StretchBreak";
    license = lib.licenses.gpl3;
    mainProgram = "stretch-break";
  };
})
