{
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
  lib,
  wrapFirefoxAddonsHook,
}:
buildNpmPackage rec {
  pname = "sidebery";
  version = "5.5.0";
  src = fetchFromGitHub {
    owner = "mbnuqw";
    repo = "sidebery";
    rev = "v${version}";
    hash = "sha256-u3LDhDobYBTKZVdR9YpNHHE/YuHPmv1LnEzkAQNjRuY=";
  };

  npmDepsHash = "sha256-ZoDR3RQ5VXsaayD50H494M/IfDrD6R3+w9m7RXVBiAo=";

  nativeBuildInputs = [
    wrapFirefoxAddonsHook
  ];

  postBuild = ''
    npm run build.ext
  '';

  installPhase = ''
    mkdir $out
    cp dist/* $out/$extid.xpi
  '';

  extid = "{3c078156-979c-498b-8990-85f7987dd929}";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/mbnuqw/sidebery";
    description = "Firefox extension for managing tabs and bookmarks in sidebar";
    maintainer = with lib.maintainers; [ colinsane ];
  };
}
