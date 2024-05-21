{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dns-filter";
  version = "0-unstable-2021-04-14";

  src = fetchFromGitHub {
    owner = "depler";
    repo = "dns-filter";
    rev = "f2e9c9b451cc4caa52e61b464f73c166313fc8b6";
    hash = "sha256-WK3xlJFlYc6u03+6HSoyBaoC9VtD/i7cP1+oqpH/sfE=";
  };

  postPatch = ''
    substituteInPlace build.sh --replace-fail "gcc" "cc"
  '';

  buildPhase = ''
    sh ./build.sh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion -Wno-error=implicit-function-declaration";

  installPhase = ''
    install -Dm755 dns-filter -t $out/bin
    install -Dm644 *.txt -t $out/share/dns-filter
  '';

  meta = with lib; {
    description = "Tiny DNS server with filtering requests";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.free;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
})
