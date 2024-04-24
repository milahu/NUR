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
    i686-linux = "0wibflldqk21phnjf6w1nkhprlaw4rgybfcdji5mv9hm47rfzjg9";
    x86_64-linux = "1gqwyqbxc705x8bb7q41m7js8ljs5j4a6rdswqfqhnb50bsgwml1";
    armv7l-linux = "0dngqwiw0g7c6ll797y0q92ihj53g9gv9bwfchfwq7dnwd6idk8l";
    aarch64-linux = "0zgksj4wc7ic37s9v3hn60fyy5ca295j3hx67c2hx4caw99gz8hb";
    x86_64-darwin = "1c66k0nzibhwj95yx4d5jqfw3ah777xv837cfkw0yp3kf4sxdr0l";
    aarch64-darwin = "0xwarpaan7b7x21nsz86cm5fcaxcvbjzf1fz6vj4hwgff41gj25s";
  };

  urlMap = {
    i686-linux = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Linux_x86_64.tar.gz";
    armv7l-linux = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Linux_armv7.tar.gz";
    aarch64-linux = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/goreleaser/goreleaser/releases/download/v1.25.1/goreleaser_Darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "goreleaser";
  version = "1.25.1";
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
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    license = lib.licenses.mit;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
      "i686-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}