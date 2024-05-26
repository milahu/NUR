{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  scdoc,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmi2html";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "shtanton";
    repo = "gmi2html";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5m3erToDFkYOV1xoM+BLWbUOgP0A7TXthzQ0Sk1Qj+U=";
  };

  nativeBuildInputs = [
    zig
    scdoc
    installShellFiles
  ];

  buildPhase = ''
    export HOME=$TMPDIR
    zig build -Drelease-small=true -Dcpu=baseline
    scdoc < doc/gmi2html.scdoc > doc/gmi2html.1
  '';

  doCheck = true;

  checkPhase = ''
    sh tests/test.sh
  '';

  installPhase = ''
    zig build --prefix $out install
    installManPage doc/gmi2html.1
  '';

  meta = {
    description = "Translate text/gemini into HTML";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sikmir ];
    platforms = lib.platforms.unix;
  };
})
