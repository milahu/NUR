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
    i686-linux = "0i1pp3jggk8jv560k4z9fr6h02yns31vz7spmdwpd9kkcsj7bs4w";
    x86_64-linux = "1m27bp7w9pr9w9ijyg4ymm3pmp552ixvxzgjm67k3nk8v70d6qsr";
    armv7l-linux = "0f6f4j7njblhbdyixd19718k8r0ri85hxg9s0pdhbx2zwy2wmsx1";
    aarch64-linux = "124k4m8zfmbjr51h6l9lf0spb39jgm3bjcc6hqahj065x6zh945x";
    x86_64-darwin = "0ccdpxviw5njx1icjky7vdl0c3klhldznqlis8gk0y2yv8hc5x31";
    aarch64-darwin = "1f0v8dm3ar4i59w4dd3hv8yv4688q76dg83zss5ai3nb584rwiaf";
  };

  urlMap = {
    i686-linux = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Linux_x86_64.tar.gz";
    armv7l-linux = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Linux_arm.tar.gz";
    aarch64-linux = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/charmbracelet/mods/releases/download/v1.2.2/mods_1.2.2_Darwin_arm64.tar.gz";
  };
  sourceRootMap = {
    i686-linux = "mods_1.2.2_Linux_i386";
    x86_64-linux = "mods_1.2.2_Linux_x86_64";
    armv7l-linux = "mods_1.2.2_Linux_arm";
    aarch64-linux = "mods_1.2.2_Linux_arm64";
    x86_64-darwin = "mods_1.2.2_Darwin_x86_64";
    aarch64-darwin = "mods_1.2.2_Darwin_arm64";
  };
in
stdenvNoCC.mkDerivation {
  pname = "mods";
  version = "1.2.2";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = sourceRootMap.${system};

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./mods $out/bin/mods
    installShellCompletion ./completions/*
  '';

  system = system;

  meta = {
    description = "AI on the command line";
    homepage = "https://charm.sh/";
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