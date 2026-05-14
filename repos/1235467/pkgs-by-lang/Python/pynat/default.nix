{ lib, python3Packages, fetchFromGitHub, callPackage }:
let
  sources = callPackage ../../../_sources/generated.nix { };
in
with python3Packages;
buildPythonApplication rec {
  pname = "pynat";

  propagatedBuildInputs = [
    six
  ];
  pyproject = true;
  build-system = [ setuptools ];
  inherit (sources.pynat) version src;
}
