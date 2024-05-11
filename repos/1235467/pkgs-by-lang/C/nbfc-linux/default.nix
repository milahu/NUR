# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, cmake
, autoreconfHook
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  # 指定包名和版本
  inherit (sources.nbfc-linux) version src;
  pname = "nbfc-linux";
  enableParallelBuilding = true;

  nativeBuildInputs = [
    #cmake
    autoreconfHook
  ];
  BuildInputs = [
  ];
  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
    "--bindir=${placeholder "out"}/bin"
  ];
}
