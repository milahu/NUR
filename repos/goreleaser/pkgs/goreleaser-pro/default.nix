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
    i686-linux = "0k4ikvjzdsslr7pd1bzb2y4a16nlr2xsfz2zzh4ydqxxfn4y7h2h";
    x86_64-linux = "0jny8l9rzjcap22pafxfvvsn7njzhqn6wwmp7lhxlg8j0x90blsp";
    armv6l-linux = "0s8wx2vaj3skca9raxbqyfdfg0g1h1clhazcwp9mm2yyb4brybvx";
    aarch64-linux = "0wzln024q9d0rjs33vrs2cwflp0dbx0qrpp59h2cg2aa9haa4242";
    x86_64-darwin = "0wc75s8m175rjvn5gzjmkr6qi28k1vqykkm4gl2z38l8c081dw8i";
    aarch64-darwin = "1lnqs4vhqliwxd4sl1vcxabqhr9vw4smi7w20zfh2lqzqan6v2p7";
  };

  urlMap = {
    i686-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Linux_x86_64.tar.gz";
    armv6l-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Linux_armv6.tar.gz";
    aarch64-linux = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/goreleaser/goreleaser-pro/releases/download/v2.0.0-pro/goreleaser-pro_Darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "goreleaser-pro";
  version = "2.0.0-pro";
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
