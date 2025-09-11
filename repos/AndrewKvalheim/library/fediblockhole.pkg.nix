{ fetchPypi
, lib
, python3
, versionCheckHook
}:

let
  inherit (builtins) placeholder;
in
python3.pkgs.buildPythonApplication rec {
  pname = "fediblockhole";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zqwvAF0mskQKIcW7pQ/f1jjTe1RJjonaIyKaqvcH+1k=";
  };

  format = "pyproject";

  propagatedBuildInputs = with python3.pkgs; [
    hatchling
    requests
    toml
  ];

  nativeCheckInputs = [ versionCheckHook ]; # Pending nixos/nixpkgs#420531
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  meta = {
    description = "Tool for automatically syncing Mastodon admin domain blocks";
    homepage = "https://github.com/eigenmagic/fediblockhole";
    license = lib.licenses.agpl3Only;
    mainProgram = "fediblock-sync";
  };
}
