{ pkgs ? import <nixpkgs> {} }:

let inherit (pkgs) callPackage;
in
{
  ahd = callPackage ./pkgs/ahd {};
}
