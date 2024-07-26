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
    x86_64-linux = "106wl20pzzz37wag0a74znkxas0fgi2w12lczzqgs00ywi3z6yvv";
    aarch64-linux = "07pschwhgghyqd8mj82djadlzjwsnlcq8rr6hmz257skya5kfs7q";
    x86_64-darwin = "1422d09qsi0n1r0g74ls4bxa3ghnw77rb4xlcbycal5vf9s8km5x";
    aarch64-darwin = "1422d09qsi0n1r0g74ls4bxa3ghnw77rb4xlcbycal5vf9s8km5x";
  };

  urlMap = {
    x86_64-linux = "https://github.com/caarlos0/timer/releases/download/v1.4.5/timer_linux_amd64.tar.gz";
    aarch64-linux = "https://github.com/caarlos0/timer/releases/download/v1.4.5/timer_linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/caarlos0/timer/releases/download/v1.4.5/timer_darwin_all.tar.gz";
    aarch64-darwin = "https://github.com/caarlos0/timer/releases/download/v1.4.5/timer_darwin_all.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "timer";
  version = "1.4.5";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./timer $out/bin/timer
    installShellCompletion ./completions/*
    installManPage ./manpages/timer.1.gz
  '';

  system = system;

  meta = {
    description = "Timer is like sleep, but reports progress.";
    homepage = "https://github.com/caarlos0/timer";
    license = lib.licenses.mit;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
