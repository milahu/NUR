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
    x86_64-linux = "18v64khsswxjbajzv14vqzvxgaf958diy2pyxg1b89bsp8zwr0xg";
    aarch64-linux = "1fh6fhhwgj8w0gg8y2kl2085r3giin7dnl7ml3sddx51kgamv81b";
    x86_64-darwin = "0dcpyrp5jpjrjcm25p9nb95568y19a8syp2vv2shn69biah28wcb";
    aarch64-darwin = "0sfli2s5gq482hzxbkps0pv7cjvj8pm7pa2kg07c5gr4z2ldgzlm";
  };

  urlMap = {
    x86_64-linux = "https://github.com/FriendsOfShopware/shopware-cli/releases/download/0.4.50/shopware-cli_Linux_x86_64.tar.gz";
    aarch64-linux = "https://github.com/FriendsOfShopware/shopware-cli/releases/download/0.4.50/shopware-cli_Linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/FriendsOfShopware/shopware-cli/releases/download/0.4.50/shopware-cli_Darwin_x86_64.tar.gz";
    aarch64-darwin = "https://github.com/FriendsOfShopware/shopware-cli/releases/download/0.4.50/shopware-cli_Darwin_arm64.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "shopware-cli";
  version = "0.4.50";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./shopware-cli $out/bin/shopware-cli
  '';
  postInstall = ''
    installShellCompletion --cmd shopware-cli \
    --bash <($out/bin/shopware-cli completion bash) \
    --zsh <($out/bin/shopware-cli completion zsh) \
    --fish <($out/bin/shopware-cli completion fish)
  '';

  system = system;

  meta = {
    description = "Command line tool for Shopware 6";
    homepage = "https://sw-cli.fos.gg";
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
