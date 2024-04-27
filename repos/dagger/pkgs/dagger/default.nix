# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{
system ? builtins.currentSystem
, pkgs
, lib
, fetchurl
, installShellFiles
}:
let
  shaMap = {
    x86_64-linux = "1bi01spsnypbz8d34pf8lnj0jdd0axjiak2iykbraygwd631ng1a";
    armv7l-linux = "0di11vwn3kixw8s087nzcd0d36a2a9y0mn25a9f6jjlr1nxdlb4c";
    aarch64-linux = "000wl25qvp9p34gvfna4y8kxkagxmw24mfy1a2a8mv6aljxwrcaj";
    x86_64-darwin = "1qsncdv77fa0720dzr572yl6mz8m2b1j6h0vkw4jfa7wg4mi88bx";
    aarch64-darwin = "0f7dgcjqlvkrfhq0cd8jmr0dav9gqxha0zil0rq1dmshg3qli1x3";
  };

  urlMap = {
    x86_64-linux = "https://dl.dagger.io/dagger/releases/0.11.2/dagger_v0.11.2_linux_amd64.tar.gz";
    armv7l-linux = "https://dl.dagger.io/dagger/releases/0.11.2/dagger_v0.11.2_linux_armv7.tar.gz";
    aarch64-linux = "https://dl.dagger.io/dagger/releases/0.11.2/dagger_v0.11.2_linux_arm64.tar.gz";
    x86_64-darwin = "https://dl.dagger.io/dagger/releases/0.11.2/dagger_v0.11.2_darwin_amd64.tar.gz";
    aarch64-darwin = "https://dl.dagger.io/dagger/releases/0.11.2/dagger_v0.11.2_darwin_arm64.tar.gz";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "dagger";
  version = "0.11.2";
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
