{ lib
, buildPythonPackage
, fetchFromGitHub
}: buildPythonPackage {
  pname = "mypackage";
  version = "0.1-unstable-2024-06-04";
  format = "pyproject";  # or setuptools

  src = fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "${version}";
  };

  propagatedBuildInputs = [
    # other python modules this depends on, if this package is supposed to be importable
  ];

  pythonImportsCheck = [
    "mymodule"
  ];

  meta = with lib; {
    homepage = "https://example.com";
    description = "python template project";
    maintainers = with maintainers; [ colinsane ];
  };
}
