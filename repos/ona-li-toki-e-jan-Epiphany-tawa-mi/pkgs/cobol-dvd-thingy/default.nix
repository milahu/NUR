{ stdenv
, fetchFromGitHub
, lib
, gnu-cobol
, gmp
}:

stdenv.mkDerivation rec {
  pname   = "cobol-dvd-thingy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ona-li-toki-e-jan-Epiphany-tawa-mi";
    repo  = "COBOL-DVD-Thingy";
    rev   = "RELEASE-V${version}";
    hash  = "sha256-+9prxsW89quwgh0miQqDpyOK+tPQXx3PrTWTL/ldLlo=";
  };

  # We have to use gnu-cobol.bin because gnu-cobol doesn't properly output it's
  # binary, I think.
  nativeBuildInputs = [ gnu-cobol.bin gmp ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${pname} $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Terminal screensaver similar to that of DVD players";
    homepage    = "https://github.com/ona-li-toki-e-jan-Epiphany-tawa-mi/COBOL-DVD-Thingy";
    license     = licenses.mit;
    mainProgram = pname;
  };
}
