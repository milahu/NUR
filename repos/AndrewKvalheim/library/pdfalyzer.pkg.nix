{ fetchPypi
, lib
, nix-update-script
, python3
, versionCheckHook

  # Dependencies
, yaralyzer
}:

let
  inherit (lib) versionAtLeast versionOlder;
in
python3.pkgs.buildPythonApplication rec {
  pname = "pdfalyzer";
  version = "1.17.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IIPnMh4B8HVV3gdsQOGwvDrUIoc7xkRnKmW47d25YN0=";
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
    broken = versionOlder python3.pkgs.pypdf.version "6.4.2" || versionAtLeast python3.pkgs.pypdf.version "6.5";
  };
}
