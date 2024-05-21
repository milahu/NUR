{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnsstk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnsstk-apps";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "SGL-UT";
    repo = "gnsstk-apps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gnw42ebL8hxRq8hX2IvTDwbqKDws9n3jmcSXLvBre8A=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gnsstk ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXT" true)
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "14")
  ];

  meta = with lib; {
    description = "GNSSTk applications suite";
    inherit (finalAttrs.src.meta) homepage;
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
  };
})
