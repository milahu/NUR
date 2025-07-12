{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gobject-introspection,
  hidapi,
  libevdev,
  libgudev,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libmanette-1";
  version = "0.2.12-unstable-2025-07-10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libmanette";
    rev = "54f317a6b354bd90b11a6da97545d038db2498f2";
    hash = "sha256-vKIy6K+jW6tXimEfEUlV3+sx7aU23OALhQHiN6zTV/0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    gobject-introspection
    hidapi
    libevdev
    libgudev
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "";
    homepage = "https://gitlab.gnome.org/GNOME/libmanette";
    changelog = "https://gitlab.gnome.org/GNOME/libmanette/-/blob/${src.rev}/NEWS";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
