{ fetchPypi
, lib
, python3
, versionCheckHook
}:

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

  # TODO: versionCheckHook

  meta = {
    description = "Tool for automatically syncing Mastodon admin domain blocks";
    homepage = "https://github.com/eigenmagic/fediblockhole";
    license = lib.licenses.agpl3Only;
    mainProgram = "fediblock-sync";
  };
}
