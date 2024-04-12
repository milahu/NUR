{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libuuid,
  rustc,
  cargo,
  corrosion,
  rustPlatform,
}:
stdenv.mkDerivation rec {
  pname = "taskwarrior3";
  version = "3.0.0-20240311";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "0c8edfc50e422b69abb4b78af70fc2243e227e9d";
    sha256 = "sha256-CNCamyEfuRjcl5aNrPuaffUauWcPuYMjJvTRTUb2bWY=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    # include version in the name so we invalidate the FOD
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-G9KfwVbCM8Go/M1xmesIlMrmECDc4w7Q0GMTrA3qpeQ=";
  };

  nativeBuildInputs = [cmake rustc cargo rustPlatform.cargoSetupHook];
  buildInputs = [libuuid];
  cmakeFlags =
    [
      "-DFETCHCONTENT_SOURCE_DIR_CORROSION=${corrosion.src}"
      "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    ]
    ++ lib.optional stdenv.cc.isClang [
      "-DCMAKE_C_COMPILER=clang"
      "-DCMAKE_CXX_COMPILER=clang++"
    ];

  meta = with lib; {
    description = "matplotlib backend for graph output in unicode terminals using drawille";
    homepage = "https://github.com/gooofy/drawilleplot";
    license = licenses.asl20;
    maintainers = with maintainers; [renesat];
    platforms = platforms.unix ++ platforms.windows;
  };
}
