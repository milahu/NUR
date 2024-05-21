{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnbcompat";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "archiecobbs";
    repo = "libnbcompat";
    rev = finalAttrs.version;
    hash = "sha256-DyBLEp5dNYSQgTzdQkGfLdCtX618EbnVy5FmL75BMdU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Portable NetBSD-compatibility library";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.free;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
})
