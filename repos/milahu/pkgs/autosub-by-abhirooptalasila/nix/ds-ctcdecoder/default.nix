{ lib
, buildPythonPackage
, python
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "ds_ctcdecoder";
  version = "0.9.3";
  disabled = python.pythonVersion != "3.9";
  format = "wheel";
  src = fetchPypi rec {
    inherit pname version format;
    sha256 = "HAKPyNImGak+dIEWhMkRO8/2rNwqQCk6/eacUicK4U0=";
    dist = python;
    python = "cp39";
    abi = "cp39";
    platform = "manylinux1_x86_64";
  };
  propagatedBuildInputs = (with python.pkgs; [
    numpy
  ]);
  doCheck = false; # TODO
  meta = with lib; {
    homepage = "https://github.com/mozilla/DeepSpeech";
    description = "DeepSpeech CTC decoder";
    license = licenses.mpl20;
  };
}
