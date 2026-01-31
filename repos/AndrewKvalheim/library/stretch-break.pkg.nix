{ fetchFromGitHub
, lib
, nix-update-script
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

let
  inherit (lib) escapeShellArg;
in
rustPlatform.buildRustPackage (stretch-break: {
  pname = "stretch-break";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "pieterdd";
    repo = "StretchBreak";
    rev = "refs/tags/${stretch-break.version}";
    hash = "sha256-gKQsoitJfGVUnpEHC4qXdesECvylJluwRDXtoNZfSFI=";
  };

  cargoHash = "sha256-LyifQ44aS7kkm7Cd6baSu5lYAWfKpDOlRFXGQFQLNU4=";

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

  doInstallCheck = true;
  # Pending compatibility with versionCheckHook
  installCheckPhase = ''
    help="$($out/bin/${escapeShellArg stretch-break.meta.mainProgram} --help)"
    echo "$help"
    [[ "$help" == *'Usage: stretch-break'* ]]
    [[ "$help" != *'version'* ]]
    [[ "$help" != *${escapeShellArg stretch-break.version}* ]]
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Helps you take regular breaks from using your computer";
    homepage = "https://github.com/pieterdd/StretchBreak";
    license = lib.licenses.gpl3;
    mainProgram = "stretch-break";
  };
})
