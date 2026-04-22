{ fetchFromGitHub
, lib
, stdenv
, unstableGitUpdater

  # Dependencies
, python3
}:

let
  inherit (lib) licenses;
in
stdenv.mkDerivation {
  pname = "gpx-reduce";
  version = "0-unstable-2022-11-18";
  meta = {
    description = "Script that removes unnecessary points from GPX files";
    homepage = "https://github.com/Alezy80/gpx_reduce";
    license = licenses.gpl3Plus;
  };

  passthru.updateScript = unstableGitUpdater { };

  src = fetchFromGitHub {
    owner = "Alezy80";
    repo = "gpx_reduce";
    rev = "2f6d6d006871dfb19a15718ed6c6717009705abc";
    hash = "sha256-unmarEs4xs5OYZg6xEdxYU+eoZnyYwpPQ/+cxouDfqE=";
  };

  buildInputs = [
    (python3.withPackages (ps: with ps; [
      iso8601
      lxml
      matplotlib
      numpy
    ]))
  ];

  doCheck = true;
  checkPhase = ''
    python3 'gpx_reduce.py' --help > '/dev/null'
  '';

  postInstall = ''
    install -D 'gpx_reduce.py' "$out/bin/gpx_reduce"
  '';
}
