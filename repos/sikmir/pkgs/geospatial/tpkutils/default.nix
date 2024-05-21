{
  lib,
  fetchFromGitHub,
  python3Packages,
  pymbtiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "tpkutils";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "consbio";
    repo = "tpkutils";
    rev = version;
    hash = "sha256-iKM+tEEOtSkwDdkBN+n35q3D2IBi7a/bnY/fSlGDowU=";
  };

  build-system = with python3Packages; [ poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    mercantile
    pymbtiles
    six
    setuptools # pkg_resources
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "ArcGIS Tile Package Utilities";
    inherit (src.meta) homepage;
    license = licenses.isc;
    maintainers = [ maintainers.sikmir ];
    mainProgram = "tpk";
  };
}
