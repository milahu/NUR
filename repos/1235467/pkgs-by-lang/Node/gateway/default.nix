# 当你使用 pkgs.callPackage 函数时，这里的参数会用 Nixpkgs 的软件包和函数自动填充（如果有对应的话）
{ lib
, stdenv
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.buildNpmPackage rec {
  inherit (sources.portkey) version src;
  pname = "gateway";
  #npmDepsHash = "sha256-XmFoQl5JMcfdfLXfah5lfaMsDq372lQiMnnabtl0yQY=";
  npmDeps = pkgs.fetchNpmDeps {
    inherit (sources.portkey) src;
    hash = "sha256-XmFoQl5JMcfdfLXfah5lfaMsDq372lQiMnnabtl0yQY=";
  };
  #npmDeps = "${sources.portkey.src}";
  nativeBuildInputs = with pkgs; [
  ];
  BuildInputs = with pkgs; [
  ];
  postInstall = ''
    cp $out/bin/@portkey-ai/gateway $out/bin/portkey-ai-gateway
  '';
}
