{ lib, python3Packages, fetchFromGitHub, callPackage }:
let
   sources = callPackage ../../../_sources/generated.nix { };
in
with python3Packages;
buildPythonApplication rec {
  pname = "pystun3";
  inherit (sources.pystun3) version src;
  propagatedBuildInputs = [
  ];
  doCheck = false;
}
