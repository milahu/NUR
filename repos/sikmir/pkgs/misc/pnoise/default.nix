{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "pnoise";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "plottertools";
    repo = "pnoise";
    rev = version;
    hash = "sha256-JwWzLvgCNSLRs/ToZNFH6fN6VLEsQTmsgxxkugwjA9k=";
  };

  propagatedBuildInputs = with python3Packages; [ numpy ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "Vectorized port of Processing noise() function";
    inherit (src.meta) homepage;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.sikmir ];
  };
}
