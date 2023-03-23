{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "clear-dark";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "naofireblade";
    repo = "clear-theme-dark";
    rev = "v${version}";
    sha256 = "0jagw2dv1rp5pk854idzcgmlxkybbjv7pc8y3jrbhz8mm081v8nk";
  };

  installPhase = ''
    mkdir $out
    cp themes/clear-dark.yaml $out/
  '';

  meta = with lib; {
    homepage = "https://github.com/naofireblade/clear-theme-dark";
    description = "Dark variant of Clear Theme for Home Assistant";
    license = licenses.mit;
  };
}
