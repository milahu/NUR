# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{
system ? builtins.currentSystem
, lib
, fetchurl
, installShellFiles
, stdenvNoCC
}:
let
  shaMap = {
    i686-linux = "0bv8vkb0jnq0plp0bm93rmz8chzi55giz4w4nv2qd7msmik680fl";
    x86_64-linux = "17bkmy2krzqkv662i2j7hscxhms74z6vc1ibgg9yavh4m0wzk1mp";
    armv6l-linux = "1n6zsnxy9bs8zd02drmvvy5nin204060d72khsvwh6jrb7d3lz94";
    aarch64-linux = "1kwr8b43lppyr9ppvhzy0f7b4wrvpm2za2i8kmv97bd594f3mn6z";
    x86_64-darwin = "0scahi0ha87slxlbyyzgxwimmz07wvqm1mvadj1yhpycqdvimpll";
    aarch64-darwin = "0bfh4i7a8qqv3k5wi583x3aayjhv8xf8qa1hmd3337ipi6scfdx0";
  };

  urlMap = {
    i686-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Linux_x86_64.tar.gz";
    armv6l-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Linux_armv6.tar.gz";
    aarch64-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.3.0-pro/goreleaser-pro_Darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "goreleaser-pro";
  version = "2.3.0-pro";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./goreleaser $out/bin/goreleaser
    installManPage ./manpages/goreleaser.1.gz
    installShellCompletion ./completions/*
  '';

  system = system;

  meta = {
    description = "Deliver Go binaries as fast and easily as possible.";
    homepage = "https://goreleaser.com";
    license = lib.licenses.unfree;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "armv6l-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
