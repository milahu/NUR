{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gsl-lite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serverpp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "KazDragon";
    repo = "serverpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z7aLE7RyRGwUCpnJr0NS6yXUBPtHTnd81JOI/tGHDo0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    gsl-lite
  ];

  meta = with lib; {
    description = "A C++ library for basic network server handling";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.mit;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
})
