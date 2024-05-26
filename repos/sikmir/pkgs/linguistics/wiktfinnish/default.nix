{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "wiktfinnish";
  version = "2020-02-27";

  src = fetchFromGitHub {
    owner = "tatuylonen";
    repo = "wiktfinnish";
    rev = "dc0ad5929664d368dc29631927b10e4641b2f0ff";
    hash = "sha256-bUwgHAu/EfAgiNJ/gP9VRHk79S5OH1CXYBGQhkf5Ppw=";
  };

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "wiktfinnish" ];

  meta = {
    description = "Finnish morphology (including verb forms, comparatives, cases, possessives, clitics)";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sikmir ];
  };
}
