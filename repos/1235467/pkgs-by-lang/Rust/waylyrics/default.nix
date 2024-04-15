{ lib, fetchFromGitHub, rustPlatform, gtk4, pkg-config, openssl, dbus, wrapGAppsHook4, glib, makeDesktopItem, pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage rec
{
  pname = "waylyrics";
  inherit (sources.waylyrics) version src;

  cargoLock.lockFile = "${sources.waylyrics.src}/Cargo.lock";
  cargoLock.outputHashes = {
    "ncmapi-0.1.13" = "sha256-gwFMmMzQywlsQC2GljgLwXoP2Cca0r24iEDmV0k/xG0=";
    "qqmusic-rs-0.1.0" = "sha256-woLsO0n+m3EBUI+PRLio7iLp0UPQSliWK0djCSZEaZc=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ gtk4 openssl dbus glib ];

  RUSTC_BOOTSTRAP = 1;

  doCheck = false; # No tests defined in the project.

  WAYLYRICS_DEFAULT_CONFIG = "${placeholder "out"}/share/waylyrics/config.toml";
  WAYLYRICS_THEME_PRESETS_DIR = "${placeholder "out"}/share/waylyrics/themes";

  postInstall = ''
    mkdir -p $out/share/waylyrics
    mkdir -p $out/share/glib-2.0/schemas
    cp  io.poly000.waylyrics.gschema.xml $out/share/glib-2.0/schemas/
    glib-compile-schemas $out/share/glib-2.0/schemas/
    mkdir -p $out/share/waylyrics/themes
    cp -arv themes/* "$out/share/waylyrics/themes/"
    cp -arv res/* "$out/share/"
    cp -vr themes $out/share/waylyrics/
    # Install schema
    mkdir -p $out/share/gsettings-schemas/waylyrics/glib-2.0/schemas
    cp io.poly000.waylyrics.gschema.xml $out/share/gsettings-schemas/waylyrics/glib-2.0/schemas/
    glib-compile-schemas $out/share/gsettings-schemas/waylyrics/glib-2.0/schemas/
    # Install icons
    cp -vr res/icons $out/share/
  '';

  meta = with lib; {
    description = "On screen lyrics for Wayland with NetEase Music source";
    homepage = "https://github.com/poly000/waylyrics";
    license = licenses.mit;
    maintainers = [ maintainers.shadowrz ];
    platforms = platforms.linux;
  };
}
