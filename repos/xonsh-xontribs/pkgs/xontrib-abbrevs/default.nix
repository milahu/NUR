{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  poetry-core,
  prompt-toolkit,
  pytestCheckHook,
  xonsh,
}:
buildPythonPackage rec {
  pname = "xontrib-abbrevs";
  version = "0.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-abbrevs";
    rev = version;
    hash = "sha256-DrZRIU5mzu8RUzm0jak/Eo12wbvWYusJpmqgIAVwe00=";
  };

  doCheck = false;

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace '"xonsh>=0.12.5", ' ""
  '';

  nativeBuildInputs = [
    setuptools
    poetry-core
  ];

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    xonsh
  ];

  meta = with lib; {
    description = "Command abbreviations. This expands input words as you type in the [xonsh shell](https://xon.sh).";
    homepage = "https://github.com/xonsh/xontrib-abbrevs";
    license = licenses.mit;
    maintainers = [maintainers.greg];
  };
}
