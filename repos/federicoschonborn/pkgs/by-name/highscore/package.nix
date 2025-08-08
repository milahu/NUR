{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  feedbackd,
  gamemode,
  glib,
  gtk4,
  libadwaita,
  libarchive,
  libepoxy,
  libgee,
  libhighscore,
  libmanette-1,
  libmirage,
  libpulseaudio,
  librsvg,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore";
  version = "0-unstable-2025-08-06";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "highscore";
    rev = "7695c06b65b8dd869338ec025b021f8dcf1da8d0";
    hash = "sha256-LAsAPTktgxT8vD7eivCPzQjd9hbYpGkbRwuq8c95e+g=";
  };

  patches = [
    (replaceVars ./vcs_tag.patch { inherit (finalAttrs.src) rev; })
  ];

  nativeBuildInputs = [
    appstream # appstreamcli
    blueprint-compiler
    desktop-file-utils # desktop-file-validate
    gettext
    glib # glib-compile-schemas
    gtk4 # gtk4-update-icon-cache
    libxml2 # xmllint
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    feedbackd
    gamemode
    glib
    gtk4
    libadwaita
    libarchive
    libepoxy
    libgee
    libhighscore
    libmanette-1
    (libmirage.overrideAttrs (
      _: prevAttrs: {
        nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [
          vala
        ];
      }
    ))
    libpulseaudio
    librsvg
    sqlite
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "highscore";
    description = "Retro gaming application for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/World/highscore";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
