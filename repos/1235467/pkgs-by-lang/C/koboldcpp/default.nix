# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, python3
, cmake
, openblas
, clblast
, ocl-icd
, writeShellApplication
, makeWrapper
, vulkan-headers
, vulkan-utility-libraries
, vulkan-loader
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in

stdenv.mkDerivation rec {
  # 指定包名和版本
  pname = "koboldcpp";
  inherit (sources.koboldcpp) version src;
#   version = "5174f9de7b9d30dc12174a865c0cef612658f5aa";
#
#   # 从 GitHub 下载源代码
#   src = fetchFromGitHub {
#     owner = "LostRuins";
#     repo = "koboldcpp";
#     rev = "5174f9de7b9d30dc12174a865c0cef612658f5aa";
#     sha256 = "sha256-KEzxxRWUnEwK5ObNEFKEzEa6go1BRfFWP81v4BD0ssg=";
#     fetchSubmodules = true;
#   };
  #   koboldcpp7B = writeShellApplication {
  #     name = "koboldcpp-7B";
  #     runtimeInputs = [ openblas clblast ocl-icd python3 ];
  #     text = ''
  #       koboldcpp --useclblast 0 0 --gpulayers 33
  #     '';
  #   };
  preConfigure = ''
  '';
  #enableParallelBuilding = false;
  # 如果基于 CMake 的软件包在打包时出现了奇怪的错误，可以尝试启用此选项
  # 此选项禁用了对 CMake 软件包的一些自动修正
  dontFixCmake = true;
  buildPhase = ''
    make -j 4 LLAMA_OPENBLAS=1 LLAMA_CLBLAST=1 LLAMA_VULKAN=1
  '';
  installPhase = ''
    mkdir -p $out/bin/
    cp -r *.so $out/bin/
    cp $src/koboldcpp.py $out/bin/koboldcpp
    chmod +x $out/bin/koboldcpp
    wrapProgram $out/bin/koboldcpp --prefix PATH : ${lib.makeBinPath [python3 openblas vulkan-loader clblast ocl-icd]}
  '';
  # 将 CMake 加入编译环境，用来生成 Makefile
  nativeBuildInputs = [ pkg-config openblas clblast ocl-icd makeWrapper vulkan-headers vulkan-utility-libraries vulkan-loader];
  BuildInputs = [ python3 cmake vulkan-headers vulkan-utility-libraries vulkan-loader];
}
