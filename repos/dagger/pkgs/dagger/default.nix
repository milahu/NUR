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
    x86_64-linux = "0bn6z1qfacrj399zlyb0nqgav68z180qhrxq4i4ivzkhzizbr4qi";
    armv7l-linux = "0n4bss4av7fhgzpgjwbk2394wplng4hgy3nxp1rb6x5v4a601lbr";
    aarch64-linux = "1vhk4d1da2yfw3qjhpf91rwyqcps8s66fbyja2az312rsc17wkh8";
    x86_64-darwin = "1bp6zycdpr4rhv62lh02mw4rik66pwvyggppa1i5fb5f4b56fd7a";
    aarch64-darwin = "1y9c684yhcxi84j747c82dv9b1jg19hcw7cmlcqrnnvqbvqaq80x";
  };

  urlMap = {
    x86_64-linux = "https://dl.dagger.io/dagger/releases/0.13.1/dagger_v0.13.1_linux_amd64.tar.gz";
    armv7l-linux = "https://dl.dagger.io/dagger/releases/0.13.1/dagger_v0.13.1_linux_armv7.tar.gz";
    aarch64-linux = "https://dl.dagger.io/dagger/releases/0.13.1/dagger_v0.13.1_linux_arm64.tar.gz";
    x86_64-darwin = "https://dl.dagger.io/dagger/releases/0.13.1/dagger_v0.13.1_darwin_amd64.tar.gz";
    aarch64-darwin = "https://dl.dagger.io/dagger/releases/0.13.1/dagger_v0.13.1_darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "dagger";
  version = "0.13.1";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./dagger $out/bin/dagger
  '';
  postInstall = ''
    installShellCompletion --cmd dagger \
    --bash <($out/bin/dagger completion bash) \
    --fish <($out/bin/dagger completion fish) \
    --zsh <($out/bin/dagger completion zsh)
  '';

  system = system;

  meta = {
    description = "Dagger is an integrated platform to orchestrate the delivery of applications";
    homepage = "https://dagger.io";
    license = lib.licenses.asl20;

    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
