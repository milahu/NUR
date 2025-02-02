{ lib, fetchFromSourcehut, rustPlatform }:
let
  rev = "b030163fb1e0c266fe03a8fd152b9b2d171c506a";
in rustPlatform.buildRustPackage rec {
    pname = "dolltags-dev";
    version = "dev-${rev}";

    src = fetchFromSourcehut {
        owner = "~artemis";
        repo = "dolltags";
        rev = rev;
        hash = "sha256-0x1aBN+HDLT0Roax5VWvtquplnG/Wa2jNEvOxDITkMs=";
    };

    cargoHash = "sha256-8RcteT3nc0YN8QNGmZq7+uYSOQyZNhEet3TfnYLybR0=";

    postInstall =
        ''
        mkdir $out/lib
        cp -r assets $out/lib/
        cp -r templates $out/lib/
        '';

    meta = with lib; {
        description = "[dev branch version] like dog tags but for dolls and entities of all kinds.";
        homepage = "https://git.sr.ht/~artemis/dolltags";
        mainprogram = "dolltags";
    };
}
