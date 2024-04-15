# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, spdlog
, libconfig
, openssl
, poco
, git
, zlib
, boost
, uriparser
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  # 指定包名和版本
  inherit (sources.candy) version src;
  pname = "candy";
#    preConfigure = ''
#     mkdir -p build/_deps
#     cp -r ${IXWebSocket} build/_deps/ixwebsocket-src
#     chmod -R +w build/_deps/
#   '';
  doCheck = false;
  enableParallelBuilding = true;

  nativeBuildInputs = [
  pkg-config
  cmake
  spdlog
  libconfig
  git
  poco
  zlib
  boost
  openssl
  uriparser
 ];
  BuildInputs = [
 openssl boost ];

  #cmakeFlags = [
  #  "-DCMAKE_BUILD_TYPE=Release"
  #];

  # stdenv.mkDerivation 自动帮你完成其余的步骤
}
