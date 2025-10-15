# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pkgs
, libsodium
, libev
, ...
} @ args:
let
  src = fetchFromGitHub {
    owner = "me-asri";
    repo = "rtptun";
    rev = "e2e2cea76b4c187d4e7da9270049f56feea4c31c";
    sha256 = "sha256-/A1KPD+TZylWMUnKI9PorHrfziAV9IctjevSN5U0aTc=";
  };
in
stdenv.mkDerivation rec {
  inherit src;
  version = "0.1.0";
  pname = "rtptun";
  doCheck = false;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    libev
    libsodium
  ];
  BuildInputs = [
    cmake
  ];

  buildPhase = ''
    make -j4 DEBUG=0 STATIC=0
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp -r bin/rel/* $out/bin/
    chmod +x -R $out/bin
  '';

}
