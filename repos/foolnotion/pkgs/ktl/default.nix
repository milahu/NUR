{ lib, stdenv, fetchFromGitHub, cmake }:
let
  cmake-utils = stdenv.mkDerivation rec {
    name = "cmake-utils";
    fetchurl = "https://raw.githubusercontent.com/karnkaul/cmake-utils/refs/heads/main/cmake-utils.cmake";
    src = builtins.fetchurl {
      url = fetchurl;
      name = "cmake-utils.cmake";
      sha256 = "sha256:1y5xjhqx05mwd5iagfcr2kyydib5lvrg7nhm59i3mpyljcyv4lky";
    };
    dontUnpack = true;
    installPhase = "install -D $src $out/" + builtins.baseNameOf fetchurl;
  };
in
stdenv.mkDerivation rec {
  pname = "ktl";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "karnkaul";
    repo = "ktl";
    rev = "v.${version}";
    hash = "sha256-5rLjW2oDuo/37jx7fDveGJGHP5HGBVL/MzMbCNf9VrM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DKTL_INSTALL=ON" "-DFETCHCONTENT_SOURCE_DIR_CMAKE-UTILS=${cmake-utils}" ];

  meta = with lib; {
    description = "A lightweight set of utility headers written in C++20.";
    homepage = "https://github.com/karnkaul/ktl";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    #maintainers = with maintainers; [ foolnotion ];
  };
}
