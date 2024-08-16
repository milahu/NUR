{
  lib,
  python3,
  fetchFromGitHub,
  aiolinkding,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "linkding-cli";
  version = "2023.10.0";
  format = "pyproject";

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "linkding-cli";
    rev = version;
    hash = "sha256-IzZvqr4r3y3IEO98EAFah4ZUBAaUVMbF775I/4BQr8w=";
  };

  nativeBuildInputs = with python3.pkgs; [poetry-core];

  propagatedBuildInputs = with python3.pkgs; [
    aiolinkding
    ruamel-yaml
    typer
    rich
    shellingham
    colorama
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "linkding_cli"
  ];

  meta = with lib; {
    description = "A CLI to interface with an instance of linkding";
    homepage = "https://github.com/bachya/linkding-cli";
    license = licenses.mit;
    maintainers = with maintainers; [renesat];
  };
}
