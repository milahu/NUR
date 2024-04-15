{ lib, writeShellApplication,pkgs,  stdenv,... }:

let
  nvfetcher = writeShellApplication rec {
  name = "nvfetcher";
  text = ''
  ${pkgs.nvfetcher}/bin/nvfetcher -c nvfetcher.toml -o _sources
  '';
  };

in
stdenv.mkDerivation rec {
  src = ./.;
  pname = "buildtools";
  inherit (nvfetcher) name;
  installPhase = ''
    mkdir -p $out/bin
    cp ${nvfetcher}/bin/nvfetcher $out/bin/nurpkgs-nvfetcher
  '';
}

