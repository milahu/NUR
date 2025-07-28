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
  version = "0-unstable-2025-07-27";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "a4c13c3deb55d2eda4f364cdbdd9a5e457cd1c62";
    hash = "sha256-xjQMzt1XIdM6duxY2A2vG/Xy8jy9xCXLN5nKheYrw8c=";
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
