{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPythonPackage,
  protobuf,
}:
buildPythonPackage rec {
  pname = "vegafusion-python-embed";
  version = "1.6.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-EoNbcMOTqyC/nFttQhWQ2iNGxSwZWkbnCL4W3O+D0As=";
  };

  buildAndTestSubdir = "vegafusion-python-embed";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-fNe5XW8LinUFhJYJTFXjCDGZkK+xDTAS4mE3gvnGKRo=";
  };

  nativeBuildInputs = with rustPlatform; [cargoSetupHook maturinBuildHook protobuf];

  pythonImportsCheck = ["vegafusion_embed"];

  meta = with lib; {
    description = "Python library that embeds the VegaFusion Runtime and select Connection";
    homepage = "https://github.com/hex-inc/vegafusion";
    license = lib.licenses.bsd3;
    maintainers = with maintainers; [renesat];
  };
}
