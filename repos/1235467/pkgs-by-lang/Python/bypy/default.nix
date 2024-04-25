{ lib, python3Packages, fetchFromGitHub, callPackage }:
let
   sources = callPackage ../../../_sources/generated.nix { };
in
with python3Packages;
buildPythonApplication rec {
  pname = "bypy";
  inherit (sources.bypy) version src;
  propagatedBuildInputs = with pkgs.python3Packages; [
  requests
  requests-toolbelt
  multiprocess
  ];
  doCheck = false;
}
