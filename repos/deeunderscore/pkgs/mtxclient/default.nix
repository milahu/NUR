# This file is a modified version of nixpkgs/pkgs/development/libraries/mtxclient/default.nix (copied at 5c4b9be)

{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, boost17x
, openssl
, olm
, spdlog
, nlohmann_json
, libevent
, curl
, coeurl
, re2
}:
stdenv.mkDerivation {
  pname = "mtxclient";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "mtxclient";
    rev = "b1a978ab30d40865b982e96e6b1d4f2fd7ac6e3e";
    hash = "sha256-9ggZ1uTtK42GtCBj+OmOroszERBxdvZtp15AMvl4Qx0=";
  };

  cmakeFlags = [
    # Network requiring tests can't be disabled individually:
    # https://github.com/Nheko-Reborn/mtxclient/issues/22
    "-DBUILD_LIB_TESTS=OFF"
    "-DBUILD_LIB_EXAMPLES=OFF"
  ];

  postPatch = ''
    # See https://github.com/gabime/spdlog/issues/1897
    sed -i '1a add_compile_definitions(SPDLOG_FMT_EXTERNAL)' CMakeLists.txt
  '';


  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    spdlog
    nlohmann_json
    boost17x
    openssl
    olm
    libevent
    curl
    coeurl
    re2
  ];

  meta = with lib; {
    description = "Client API library for Matrix, built on top of Boost.Asio";
    homepage = "https://github.com/Nheko-Reborn/mtxclient";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz pstn ];
    platforms = platforms.all;
    # Should be fixable if a higher clang version is used, see:
    # https://github.com/NixOS/nixpkgs/pull/85922#issuecomment-619287177
    broken = stdenv.targetPlatform.isDarwin;
  };
}
