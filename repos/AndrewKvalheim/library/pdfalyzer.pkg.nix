{ fetchPypi
, lib
, nix-update-script
, python3
, versionCheckHook

  # Dependencies
, yaralyzer
}:

let
  inherit (import ../library/utilities.lib.nix { inherit lib; }) versionsSatisfied;
in
python3.pkgs.buildPythonApplication rec {
  pname = "pdfalyzer";
  version = "1.19.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KmRBG/EAjVQJMgo0TXpmJm2exShbTtWxTFM5/Z/xYQ4=";
  };

  format = "pyproject";
  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [ anytree pypdf yaralyzer ];

  nativeCheckInputs = [ versionCheckHook ]; # Pending nixos/nixpkgs#420531

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Analyze PDFs with colors (and YARA)";
    homepage = "https://github.com/michelcrypt4d4mus/pdfalyzer";
    license = lib.licenses.gpl3Only;
    mainProgram = "pdfalyze";
    broken = with python3.pkgs; ! versionsSatisfied [
      [ pypdf "6.6.0" ]
      [ yaralyzer "1.3.10" ]
    ];
  };
}
