{
  stdenv,
  fetchFromGitLab,
  lib,
  libtiff,
  meson,
  ninja,
  pkg-config,
  scdoc,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "libdng";
  version = "0.2.1-unstable-2025-10-22";

  src = fetchFromGitLab {
    owner = "megapixels-org";
    repo = "libdng";
    rev = "70e359d2bbe3aa7f95f69115363986e33de682a4";
    hash = "sha256-/OMLMbgbajvB/c0Z3aJHpbuRO2aiUJ+eVwJzsclrxgM=";
  };

  depsBuildBuild = [
    pkg-config # to find scdoc for cross builds
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    libtiff
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Interface library between libtiff and the world to make sure the output is valid DNG";
    homepage = "https://libdng.me.gapixels.me";
    license = licenses.mit;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}
