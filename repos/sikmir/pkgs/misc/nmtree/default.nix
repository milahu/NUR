{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libnbcompat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nmtree";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "archiecobbs";
    repo = "nmtree";
    rev = finalAttrs.version;
    hash = "sha256-0NlrWnSi0Eyz9WlTX1OpU3dHpgZMOF0rtf9cY5mLDkc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libnbcompat ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  meta = {
    description = "NetBSD's mtree(8) utility";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.linux;
    skip.ci = true;
  };
})
