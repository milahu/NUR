{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeopcua";
  version = "0-unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "freeopcua";
    rev = "6eac0975636425d2e122b228ca69fea2d30c9ce6";
    hash = "sha256-Vf2+VDiW11aVRY8hAzdQBxQjwDWG/tVzXSw7aU/Gd9c=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  cmakeFlags = [ (lib.cmakeBool "SSL_SUPPORT_MBEDTLS" false) ];

  meta = {
    description = "Open Source C++ OPC-UA Server and Client Library";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.unix;
  };
})
