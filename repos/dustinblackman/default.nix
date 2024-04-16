# DO NOT EDIT. This file is auto generated by ./scripts/generate-default.sh
{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  languagetool-code-comments = pkgs.callPackage ./pkgs/languagetool-code-comments.nix { };
  oatmeal = pkgs.callPackage ./pkgs/oatmeal.nix { };
}