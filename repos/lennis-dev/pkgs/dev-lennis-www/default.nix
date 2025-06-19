{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  name = "dev-lennis-www-${version}";
  version = "1125fc5";
  src = fetchFromGitHub {
    owner = "lennis-dev";
    repo = "lennis.dev";
    rev = "1125fc59b79ed663ad805838520b4a4384c08096";
    hash = "sha256-PNMJZIrBcWPlfKxhBl93FqIgqQJIGVa2CC2DhPFuKVo=";
  };

  installPhase = ''
    mkdir -p $out/www
    shopt -s dotglob
    cp -r ${src}/* $out/www
  '';

  meta = with lib; {
    description = "Lennis.dev website";
    license = licenses.mit;
    homepage = "https://www.lennis.dev/";
  };
}
