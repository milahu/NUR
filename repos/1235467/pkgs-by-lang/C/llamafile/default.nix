# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, cmake
, pkg-config
, unzip
, wget
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  cosmocc = pkgs.fetchzip {
    url = "https://github.com/jart/cosmopolitan/releases/download/3.3.4/cosmocc-3.3.4.zip";
    sha256 = "sha256-SQFbuO05+ROQzghU+L/oFdAkN2a89v57X1zuutz0IaM=";
    stripRoot=false;
  };
in
stdenv.mkDerivation rec {
  inherit (sources.llamafile) version src;
  pname = "llamafile";
  preConfigure = ''
  '';
  patches = [ ./local.patch ];
  doCheck = false;
  enableParallelBuilding = true;
  buildPhase = ''
      cp -r ${cosmocc} cosmocc
      chmod +x -R cosmocc
      make -j8
  '';

  nativeBuildInputs = [
  pkg-config
  wget
  unzip
 ];
  BuildInputs = [
  cmake
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp o/llamafile/zipalign $out/bin/zipalign
	cp o/llamafile/tokenize $out/bin/llamafile-tokenize
	cp o/llama.cpp/main/main $out/bin/llamafile
	cp o/llama.cpp/imatrix/imatrix $out/bin/llamafile-imatrix
	cp o/llama.cpp/quantize/quantize $out/bin/llamafile-quantize
	cp build/llamafile-convert $out/bin/llamafile-convert
	cp o/llama.cpp/perplexity/perplexity $out/bin/llamafile-perplexity
	cp o/llama.cpp/llava/llava-quantize $out/bin/llava-quantize
  '';

}
