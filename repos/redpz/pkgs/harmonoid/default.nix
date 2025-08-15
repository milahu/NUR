{
  fetchurl,
  stdenvNoCC,
  makeWrapper,
  mpv,
  libepoxy,
  harfbuzz,
  lib,
}:
stdenvNoCC.mkDerivation {
  name = "harmonoid";
  version = "1.0.0";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    mpv
    libepoxy
    harfbuzz
  ];

  src = fetchurl {
    url = "https://release-assets.githubusercontent.com/github-production-release-asset/517078563/a5b9c5fe-7f12-498d-b078-ef2c2c3404fa?sp=r&sv=2018-11-09&sr=b&spr=https&se=2025-08-15T00%3A18%3A46Z&rscd=attachment%3B+filename%3Dharmonoid-linux-x86_64.tar.gz&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2025-08-14T23%3A18%3A05Z&ske=2025-08-15T00%3A18%3A46Z&sks=b&skv=2018-11-09&sig=04TrGNEkgTFsVIZzRVvUiRRelneR8xRxl%2B5TcMWD214%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc1NTIxNTEwNiwibmJmIjoxNzU1MjE0ODA2LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.AVmdxhrm06xSLOC9lPb0Yo-_oi3z-1SYrU9gi2VX_ak&response-content-disposition=attachment%3B%20filename%3Dharmonoid-linux-x86_64.tar.gz&response-content-type=application%2Foctet-stream";
    hash = "sha256-GTF9KrcTolCc1w/WT0flwlBCBitskFPaJuNUdxCW9gs=";
  };

  installPhase = ''
    tar -xf $src
    mkdir -p $out
    cp -r usr/bin usr/share $out/
    wrapProgram $out/bin/harmonoid \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          harfbuzz
          mpv
          libepoxy
        ]
      }
  '';

}
