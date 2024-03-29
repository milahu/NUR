{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-asyncio
, pytest-runner
}:

buildPythonPackage rec {
  pname = "async-property";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ryananguiano";
    repo = "async_property";
    rev = "v${version}";
    sha256 = "sha256-Bn8PDAGNLeL3/g6mB9lGQm1jblHIOJl2w248McJ3oaE=";
  };

  propagatedBuildInputs = [
  ];

  checkInputs = [
    pytest
    pytest-asyncio
    pytest-runner
  ];

  pythonImportsCheck = [ "async_property" ];

  meta = with lib; {
    homepage = "https://github.com/ryananguiano/async_property";
    description = "Python decorator for async properties";
    license = licenses.mit;
    maintainers = with maintainers; [ graham33 ];
  };
}
