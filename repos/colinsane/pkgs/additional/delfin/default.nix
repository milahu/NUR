{ lib
, stdenv
, appstream
, cargo
, desktop-file-utils
, fetchFromGitea
, gitUpdater
, gtk4
, libadwaita
, libglvnd
, libepoxy
, meson
, mpv-unwrapped
, ninja
, openssl
, pkg-config
, rustc
, rustPlatform
, wrapGAppsHook4
, devBuild ? false, git
}:

stdenv.mkDerivation rec {
  pname = "delfin";
  version = "0.4.4";

  src = if devBuild then fetchFromGitea {
    domain = "git.uninsane.org";
    owner = "colin";
    repo = "delfin";
    rev = "dev-sane";
    hash = "sha256-l/Lm9dUtYfWbf8BoqNodF/5s0FzxhI/dyPevcaeyPME=";
  } else fetchFromGitea {
    domain = "codeberg.org";
    owner = "avery42";
    repo = "delfin";
    rev = "v${version}";
    hash = "sha256-qbl0PvGKI3S845xLr0aXf/uk2uuOXMjvu9S3BOPzxa0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Js1mIotSOayYDjDVQMqXwaeSC2a1g1DeqD6QmeWwztk=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ] ++ lib.optionals devBuild [
    git
  ];

  buildInputs = [
    gtk4
    libadwaita
    libglvnd
    libepoxy
    mpv-unwrapped
    openssl
  ];

  mesonFlags = lib.optionals (!devBuild) [
    "-Dprofile=release"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "stream movies and TV shows from Jellyfin";
    homepage = "https://www.delfin.avery.cafe/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ colinsane ];
  };
}
