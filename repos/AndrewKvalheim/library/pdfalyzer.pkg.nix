{ fetchPypi
, lib
, python3
, versionCheckHook

  # Dependencies
, yaralyzer
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pdfalyzer";
  version = "1.17.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-80Q6iHS2TZZmGF8bBw+uvhJjEyZMMxRj1U1wUSv7GhM=";
  };

  format = "pyproject";
  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [ anytree pypdf yaralyzer ];

  nativeCheckInputs = [ versionCheckHook ]; # Pending nixos/nixpkgs#420531

  meta = {
    description = "Analyze PDFs with colors (and YARA)";
    homepage = "https://github.com/michelcrypt4d4mus/pdfalyzer";
    license = lib.licenses.gpl3Only;
    mainProgram = "pdfalyze";
    broken = lib.versionOlder yaralyzer.version "1";
  };
}
