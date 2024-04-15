# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, fetchFromGitHub
, gcc
, curl
, ...
} @ args:

stdenv.mkDerivation rec {
  # 指定包名和版本
  pname = "kagi-cli-shortcut";
  version = "f8be9a46c8156ad0886283b087a0b619c47f7473";

  # 从 GitHub 下载源代码
  src = ./.;
  #  owner = "timdesrochers";
  #  repo = pname;
  # 对应的 commit 或者 tag，注意 fetchFromGitHub 不能跟随 branch！
  #   rev = version;
  # 下载 git submodules，绝大部分软件包没有这个
  #  fetchSubmodules = true;
  # 这里的 SHA256 校验码不会算怎么办？先注释掉，然后构建这个软件包，Nix 会报错，并提示你正确的校验码
  #  sha256 = "sha256-EupSMWFkrKyMb/vP9tIr1vSK3AmcK7HHVE3Y6zfAICE=";
  #});
  #preConfigure = ''

  #'';
  #    preConfigure = ''
  #     mkdir -p build/_deps
  #     cp -r ${IXWebSocket} build/_deps/ixwebsocket-src
  #     chmod -R +w build/_deps/
  #   '';
  doCheck = false;

  #patches = [ ./linux.patch ];
  # 并行编译，大幅加快打包速度，默认是启用的。对于极少数并行编译会失败的软件包，才需要禁用。
  enableParallelBuilding = true;
  # 如果基于 CMake 的软件包在打包时出现了奇怪的错误，可以尝试启用此选项
  # 此选项禁用了对 CMake 软件包的一些自动修正
  #dontFixCmake = true;
  buildPhase = ''
    gcc -o kagi ./kagi-cli-shortcut.c -lcurl
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp kagi $out/bin
  '';
  # 将 CMake 加入编译环境，用来生成 Makefile
  nativeBuildInputs = [ gcc curl ];
  BuildInputs = [ ];


  # stdenv.mkDerivation 自动帮你完成其余的步骤
}
