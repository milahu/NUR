{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, algopy
, numpy
, scipy
, statsmodels
, pytestrunner
  # test inputs
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "numdifftools";
  version = "0.9.40";

  src = fetchFromGitHub {
    owner = "pbrod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YLi9cNHcZ/PlhrhvYOMfRTOt4kinQcfxvqInT8/0Qpg=";
  };

  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [
    algopy
    numpy
    scipy
    statsmodels
  ];

  # disable deprecated pytest-pep8 plugin which is not updated for pytest v6.0
  postPatch = "substituteInPlace setup.cfg --replace '--pep8' ''";

  doCheck = false;
  pythonImportsCheck = [ "numdifftools" ];
  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  pytestFlagsArray = [
    "-m 'not slow'"
    "--disable-warnings"
  ];

  disabledTests = [
    "test_high_order_derivative"
    "TestDoProfile"
    "test_derivative_of_cos_x"

    # Fails due to small numerical error on GitHub Actions (1.4e-14 vs expected < 1e-14)
    "test_derivative_with_step_options"
    "test_fun_with_additional_parameters"
  ];

  meta = with lib; {
    description = "Solve automatic numerical differentiation problems in one or more variables.";
    homepage = "https://numdifftools.readthedocs.io/en/stable/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
