{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildPythonPackage,
  callPackage,
  protobuf,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "vl-convert-python";
  version = "1.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vega";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-emydeonsIFlTc76kTbxNQ7aEmm4FZVYOre+bBhW6fX8=";
  };

  buildAndTestSubdir = "vl-convert-python";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qyKOqpbe4UP/JADj/k5s1u+wUfQiRTNe0xO9EebdqYw=";
  };

  nativeBuildInputs = with rustPlatform; [cargoSetupHook maturinBuildHook protobuf];

  nativeCheckInputs = [pytestCheckHook];
  pythonImportsCheck = ["vl_convert"];
  disabledTestPaths = [
    # Tests requires pypdfium2
    "vl-convert-python/tests/test_specs.py"
  ];

  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix {};
}
