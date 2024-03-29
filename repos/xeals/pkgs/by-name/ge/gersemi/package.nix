{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gersemi";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K8ZbVVYiEazdjbuAUa8r9lJyjOPt2jsKbUAovTx9XeY=";
  };

  # Remove dataclasses backport requirement since it doesn't work on newer
  # Python.
  patchPhase = ''
    sed -i '/dataclasses/d' setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    colorama
    lark
    pyyaml
  ];

  meta = {
    description = "A formatter to make your CMake code the real treasure";
    homepage = "https://github.com/BlankSpruce/gersemi";
    license = lib.licenses.mpl20;
    platforms = python3.meta.platforms;
  };
}
