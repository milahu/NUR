{ fetchFromGitHub
, lib
, stdenv

  # Dependencies
, python3
}:

let
  inherit (builtins) toFile;

  python = python3.withPackages (p: with p; [
    icalendar
    more-itertools
    pydantic
    pydash
    requests
    requests-cache
    requests-ratelimiter
    sunrisesunset
    xdg-base-dirs
  ]);
in
stdenv.mkDerivation (office-hours: {
  pname = "office-hours";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "AndrewKvalheim";
    repo = "office-hours";
    rev = "refs/tags/v${office-hours.version}";
    hash = "sha256-H8833GIYi3YfjSUpd25NpXOqHlv+JEURpylERt75wLE=";
  };

  patches = [
    (toFile "without-uv.patch" ''
      --- a/office-hours.py
      +++ b/office-hours.py
      @@ -1 +1 @@
      -#!/usr/bin/env -S uv run --script
      +#!/usr/bin/env python3
    '')
  ];

  buildInputs = [ python ];

  postInstall = ''
    install -D 'office-hours.py' "$out/bin/office-hours"
  '';

  meta = {
    description = "Generate a calendar of office hours";
    homepage = "https://github.com/AndrewKvalheim/office-hours";
    license = lib.licenses.gpl3;
    mainProgram = "office-hours";
  };
})
