{ lib
, mkDerivation
, makeWrapper
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtquickcontrols2
, qtdeclarative
, qtgraphicaleffects
, kirigami2
, oathToolkit
, ki18n
, libsodium
}:

mkDerivation rec {
  pname = "keysmith";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "keysmith";
    rev = "v${version}";
    sha256 = "1gvzw23mly8cp7ag3xpbngpid9gqrfj8cyv9dar6i9j660bh03km";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper ];

  buildInputs = [ libsodium ki18n kirigami2 qtquickcontrols2 qtbase ];

  meta = with lib; {
    description = "OTP client for Plasma Mobile and Desktop";
    license = licenses.gpl3;
    homepage = "https://github.com/KDE/keysmith";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
