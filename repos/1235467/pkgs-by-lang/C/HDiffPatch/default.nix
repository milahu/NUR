# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, xz
, lzma
, bzip2
, zstd
, zlib
, ...
} @ args:
let
  lzma = fetchFromGitHub {
    owner = "sisong";
    repo = "lzma";
    rev = "e2ff7f0c42d722bad95cce4a26966eaf8685487d";
    sha256 = "sha256-iF5HGJI592ikzf2gYwlQtSmHmrUrLxfn13TWrG9+yZU=";
    fetchSubmodules = true;
  };
  zstd = fetchFromGitHub {
    owner = "sisong";
    repo = "zstd";
    rev = "db2ba8ffc12a8222c27a4d7964a65c57459ddf92";
    sha256 = "sha256-1zs+4kl92Ps9hJTSO8VBjBZqJmcEmMNDcEijh3Y41Sk=";
    fetchSubmodules = true;
  };
  md5 = fetchFromGitHub {
    owner = "sisong";
    repo = "libmd5";
    rev = "51edeb63ec3f456f4950922c5011c326a062fbce";
    sha256 = "sha256-xjr3WQvG28xDPAONtE6jYkW8nlMfV0KL6HE4csI08YI=";
    fetchSubmodules = true;
  };
in
stdenv.mkDerivation rec {
  # 指定包名和版本
  pname = "HDiffPatch";
  version = "e2d205200b5dc798880f373c79cbd01d7319f969";

  # 从 GitHub 下载源代码
  src = fetchFromGitHub ({
    owner = "sisong";
    repo = pname;
    # 对应的 commit 或者 tag，注意 fetchFromGitHub 不能跟随 branch！
    rev = version;
    # 下载 git submodules，绝大部分软件包没有这个
    fetchSubmodules = true;
    # 这里的 SHA256 校验码不会算怎么办？先注释掉，然后构建这个软件包，Nix 会报错，并提示你正确的校验码
    sha256 = "sha256-+RyvbBvwoxbiiOBGgrpVxBvF/Ahlqogt8F5+njpVMu8=";
  });
  preConfigure = ''
    cp -r ${lzma} ./lzma
    cp -r ${zstd} ./zstd
    cp -r ${md5} ./libmd5
    chmod 777 -R lzma/
    chmod 777 -R zstd/
    chmod 777 -R libmd5/
  '';
  #    preConfigure = ''
  #     mkdir -p build/_deps
  #     cp -r ${IXWebSocket} build/_deps/ixwebsocket-src
  #     chmod -R +w build/_deps/
  #   '';
  #   doCheck = false;
  patches = [ ./local.patch ];
  # 并行编译，大幅加快打包速度，默认是启用的。对于极少数并行编译会失败的软件包，才需要禁用。
  enableParallelBuilding = true;
  # 如果基于 CMake 的软件包在打包时出现了奇怪的错误，可以尝试启用此选项
  # 此选项禁用了对 CMake 软件包的一些自动修正
  #dontFixCmake = true;
  buildPhase = ''
    make LZMA=0 ZSTD=0 MD5=0
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp hdiffz $out/bin
    cp hpatchz $out/bin
  '';
  # 将 CMake 加入编译环境，用来生成 Makefile
  nativeBuildInputs = [ pkg-config bzip2 xz zstd lzma zlib ];
  BuildInputs = [ bzip2 xz zstd lzma zlib ];


  # stdenv.mkDerivation 自动帮你完成其余的步骤
}
