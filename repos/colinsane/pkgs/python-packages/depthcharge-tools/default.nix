{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}: buildPythonPackage rec {
  pname = "depthcharge-tools";
  version = "0.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alpernebbi";
    repo = "depthcharge-tools";
    rev = "v${version}";
    hash = "sha256-3xPRNDUXLOwYy8quMfYSiBfzQl4peauTloqtZBGbvlw=";
  };

  propagatedBuildInputs = [
    setuptools  #< needs `pkg_resources` at runtime
  ];

  pythonImportsCheck = [
    "depthcharge_tools"
  ];

  meta = with lib; {
    homepage = "https://github.com/alpernebbi/depthcharge-tools";
    description = "Tools to manage the Chrome OS bootloader";
    maintainers = with maintainers; [ colinsane ];
  };
}
