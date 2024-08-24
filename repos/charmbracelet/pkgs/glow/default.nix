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
    i686-linux = "0azr08564hkx2fiws8zgkpq1zvjp3hkagmnw1m604lnk0cnkdwd9";
    x86_64-linux = "1rca0pr2x68alg7qjb2bxwx8iyw216q33s9rlbci2lj52vy6fq61";
    armv7l-linux = "09rnv86jwzssgxb4kk39xgpnn0h0cpy3pbx7z1harbc8lx3rrb8l";
    aarch64-linux = "0k002a5hxbayjvl8jyz6ycdqxnfmag81i5xl5r7cdrp87qwplcb9";
    x86_64-darwin = "0x72md8kjdbwi71dpkikww1nli264zwq7ji20wk2yxb6g3595n34";
    aarch64-darwin = "1dmwqh638wcscw35za4yqkklmh2pw0dv3js0lfhdb7wlgq75w5q4";
  };

  urlMap = {
    i686-linux = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_i386.tar.gz";
    x86_64-linux = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_x86_64.tar.gz";
    armv7l-linux = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_arm.tar.gz";
    aarch64-linux = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/charmbracelet/glow/releases/download/v2.0.0/glow_2.0.0_Darwin_arm64.tar.gz";
  };
  sourceRootMap = {
    i686-linux = "glow_2.0.0_Linux_i386";
    x86_64-linux = "glow_2.0.0_Linux_x86_64";
    armv7l-linux = "glow_2.0.0_Linux_arm";
    aarch64-linux = "glow_2.0.0_Linux_arm64";
    x86_64-darwin = "glow_2.0.0_Darwin_x86_64";
    aarch64-darwin = "glow_2.0.0_Darwin_arm64";
  };
in
stdenvNoCC.mkDerivation {
  pname = "glow";
  version = "2.0.0";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = sourceRootMap.${system};

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./glow $out/bin/glow
    installManPage ./manpages/glow.1.gz
    installShellCompletion ./completions/*
  '';

  system = system;

  meta = {
    description = "Render markdown on the CLI, with pizzazz!";
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
