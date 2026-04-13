{ fetchPypi
, lib
, nix-update-script
, python3Packages
, versionCheckHook
}:

let
  inherit (import ../library/utilities.lib.nix { inherit lib; }) versionsSatisfied;
in
python3Packages.buildPythonApplication rec {
  pname = "smartcut";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-37j/Oml2LEUUforDrKydh1iVIAEaQH8Qa8GDXdyIP9o=";
  };

  format = "pyproject";
  nativeBuildInputs = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    av
    numpy
    tqdm
  ];

  nativeCheckInputs = [ versionCheckHook ]; # Pending nixos/nixpkgs#420531
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cut video files with minimal recoding";
    homepage = "https://github.com/skeskinen/smartcut";
    license = lib.licenses.mit;
    mainProgram = "smartcut";
    broken = with python3Packages; ! versionsSatisfied [
      [ av "16.0.1" ]
    ];
  };
}
