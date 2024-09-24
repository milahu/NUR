{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "gtl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "greg7mdp";
    repo = "gtl";
    rev = "v${version}";
    sha256 = "sha256-kSmHgcaCZDNgNZdGqacrUa7d6iTtDm9BVazXUPnI5Zc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DGTL_INSTALL=ON"
    "-DGTL_BUILD_TESTS=OFF"
    "-DGTL_BUILD_EXAMPLES=OFF"
    "-DGTL_BUILD_BENCHMARKS=OFF"
  ];

  meta = with lib; {
    description = "Greg's template library of useful classes";
    homepage = "https://github.com/greg7mdp/gtl";
    license = licenses.asl20;
    platforms = platforms.all;
    #maintainers = with maintainers; [ foolnotion ];
  };
}
