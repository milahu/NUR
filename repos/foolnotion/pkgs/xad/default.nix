{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "xad";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "auto-differentiation";
    repo = "xad";
    rev = "v${version}";
    hash = "sha256-Y07nkpdAHbA3qdvmfXunNodpL20RYX00geS8yljv09M=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DXAD_ENABLE_TESTS=OFF"
    "-DXAD_POSITION_INDEPENDENT_CODE=ON"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "${if stdenv.targetPlatform.isx86_64 then "-DXAD_SIMD_OPTION=AVX2" else ""}"
  ];

  meta = with lib; {
    description = "C++ library for automatic differentiation";
    homepage = "https://github.com/auto-differentiation/XAD";
    license = licenses.agpl3Only;
    platforms = platforms.all;
    #maintainers = with maintainers; [ foolnotion ];
  };
}
