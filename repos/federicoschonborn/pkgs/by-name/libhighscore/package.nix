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
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "libhighscore";
  version = "0-unstable-2025-08-20";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "61950dfa5edbf503c28b1b6fa09d40c435e0c83b";
    hash = "sha256-6GnUM2WQfTiQGTuXI4KjV5r3a7eXSPbiICAD74uh5sA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Interface for porting emulators to
Highscore";
    homepage = "https://gitlab.gnome.org/alicem/libhighscore";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
}
