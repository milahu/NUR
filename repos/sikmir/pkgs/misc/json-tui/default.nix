{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ftxui,
  nlohmann_json,
  libargs,
}:

stdenv.mkDerivation rec {
  pname = "json-tui";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "json-tui";
    rev = "v${version}";
    hash = "sha256-Rgan+Pki4kOFf4BiNmJV4mf/rgyIGgUVP1BcFCKG25w=";
  };

  patches = [ ./no-deps.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    ftxui
    nlohmann_json
    libargs
  ];

  meta = {
    description = "A JSON terminal UI made in C++";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.unix;
  };
}
