{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gqrx-scanner";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "neural75";
    repo = "gqrx-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CHM1Q54ephZA4vNUPnaLCncgnfSiNeUq6u+X6PhhxD8=";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-DOSX";

  meta = with lib; {
    description = "A frequency scanner for Gqrx Software Defined Radio receiver";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.mit;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
})
