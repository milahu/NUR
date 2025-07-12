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
  version = "0-unstable-2025-07-10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "6212fafca49af0a01fbcedf40efe13cebcd0e0ee";
    hash = "sha256-VMCjEgkzzTHLVUnltYgHxpY8uirS2bwUNsfXrmB//Rs=";
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
