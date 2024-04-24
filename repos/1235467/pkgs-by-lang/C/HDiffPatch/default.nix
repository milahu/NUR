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
  pname = "HDiffPatch";
  version = "e2d205200b5dc798880f373c79cbd01d7319f969";

  src = fetchFromGitHub ({
    owner = "sisong";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
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
  enableParallelBuilding = true;
  buildPhase = ''
    make LZMA=0 ZSTD=0 MD5=0
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp hdiffz $out/bin
    cp hpatchz $out/bin
  '';

  nativeBuildInputs = [ pkg-config bzip2 xz zstd lzma zlib ];
  BuildInputs = [ bzip2 xz zstd lzma zlib ];
}
