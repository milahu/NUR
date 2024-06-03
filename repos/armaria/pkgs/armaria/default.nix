# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{
system ? builtins.currentSystem
, pkgs
, lib
, fetchurl
, installShellFiles
, makeWrapper
, stdenv
, unzip
}:
let
  shaMap = {
    x86_64-linux = "1kxq11jjgwmb9prg2kpnxb7hgjdll4rhkxhybrhprrs1z0bcnqfc";
  };

  urlMap = {
    x86_64-linux = "https://github.com/JonathanHope/armaria/releases/download/v0.0.39/armaria_0.0.39_linux_amd64.zip";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "armaria";
  version = "0.0.39";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles unzip ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./armaria $out/bin/armaria
  '';

  system = system;

  meta = {
    description = "Armaria is a fast, open, and local first bookmarks manager.";
    homepage = "https://github.com/JonathanHope/armaria";
    license = lib.licenses.mit;

    platforms = [
      "x86_64-linux"
    ];
  };
}
