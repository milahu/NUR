{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  allegro5,
  libglvnd,
  surgescript,
  physfs,
  xorg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensurge";
  version = "0.6.1.2";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "opensurge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HvpKZ62mYy7XkZOnIn7QRA2rFVREFnKO1NO83aCR76k=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    allegro5
    libglvnd
    physfs
    surgescript
    xorg.libX11
  ];

  cmakeFlags = [
    "-DDESKTOP_ICON_PATH=${placeholder "out"}/share/pixmaps"
    "-DDESKTOP_METAINFO_PATH=${placeholder "out"}/share/metainfo"
    "-DDESKTOP_ENTRY_PATH=${placeholder "out"}/share/applications"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A fun 2D retro platformer inspired by Sonic games and a game creation system";
    homepage = "https://github.com/alemart/opensurge";
    changelog = "https://github.com/alemart/opensurge/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
