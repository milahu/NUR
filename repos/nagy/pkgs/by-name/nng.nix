{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nng";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BBYfJ2j2IQkbluR3HQjEh1zFWPgOVX6kfyI0jG741Y4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "nanomsg-next-generation -- light-weight brokerless messaging";
    homepage = "https://github.com/nanomsg/nng";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "nngcat";
  };
})
