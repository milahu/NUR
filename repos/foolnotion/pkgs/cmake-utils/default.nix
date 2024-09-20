{ lib, stdenv }:
stdenv.mkDerivation rec {
  name = "cmake-utils";
  version = "1.0.1";
  fetchurl = "https://raw.githubusercontent.com/karnkaul/cmake-utils/refs/tags/v${version}/cmake-utils.cmake";
  src = builtins.fetchurl {
    url = fetchurl;
    name = "cmake-utils.cmake";
    sha256 = "sha256:1y5xjhqx05mwd5iagfcr2kyydib5lvrg7nhm59i3mpyljcyv4lky";
  };
  dontUnpack = true;
  installPhase = "install -D $src $out/" + builtins.baseNameOf fetchurl;

  meta = with lib; {
    description = "Utility functions for CMake projects";
    homepage = "https://github.com/karnkaul/cmake-utils";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
