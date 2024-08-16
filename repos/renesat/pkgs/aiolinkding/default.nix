{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonPackage rec {
  pname = "aiolinkding";
  version = "2023.10.0";
  format = "pyproject";

  disabled = python3.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aiolinkding";
    rev = version;
    hash = "sha256-fH2V2gmYuMlqIgWwKh3xXYYtu9bw8Ae7I58yLrYRGXE=";
  };

  postPatch = ''
  '';

  nativeBuildInputs = with python3.pkgs; [poetry-core];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    (certifi.overrideAttrs (
      _: rec {
        version = "2023.07.22";
        src = fetchFromGitHub {
          owner = "certifi";
          repo = "python-certifi";
          rev = version;
          hash = "sha256-V3bptJDNMGXlCMg6GHj792IrjfsG9+F/UpQKxeM0QOc=";
        };
      }
    ))

    packaging
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    aresponses
  ];

  pytestFlagsArray = [
    "--fixtures"
    "tests/"
  ];

  pythonImportsCheck = [
    "aiolinkding"
  ];

  meta = with lib; {
    description = "A Python3, async interface to the linkding REST API";
    homepage = "https://github.com/bachya/aiolinkding";
    license = licenses.mit;
    maintainers = with maintainers; [renesat];
  };
}
