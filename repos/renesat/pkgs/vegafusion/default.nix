{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  # Deps
  altair,
  pyarrow,
  pandas,
  psutil,
  protobuf,
  packaging, # python >= 3.12
  vl-convert-python, # embed
  vegafusion-python-embed, # embed
}:
buildPythonPackage rec {
  pname = "vegafusion";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-EoNbcMOTqyC/nFttQhWQ2iNGxSwZWkbnCL4W3O+D0As=";
  };

  patches = lib.lists.optional (pythonAtLeast "3.12") ./replace_distutils.patch; # Fix for replace deprecated distutils

  sourceRoot = "${src.name}/python/vegafusion";

  doCheck = false;

  propagatedBuildInputs =
    [
      altair
      pyarrow
      pandas
      psutil
      protobuf
    ]
    ++ lib.lists.optional (pythonAtLeast "3.12") packaging;

  optional-dependencies = {
    embed = [
      vegafusion-python-embed
      vl-convert-python
    ];
  };

  meta = with lib; {
    description = "Core tools for using VegaFusion from Python";
    homepage = "https://github.com/hex-inc/vegafusion";
    license = lib.licenses.bsd3;
    maintainers = with maintainers; [renesat];
  };
}
