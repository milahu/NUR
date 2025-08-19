{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "0.7";
in

python3Packages.buildPythonPackage {
  pname = "gwebsockets";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sugarlabs";
    repo = "gwebsockets";
    tag = "v${version}";
    hash = "sha256-YvugAed4WpXqAItfzSzkxMOgQ2Q5Y2VWLz02DL4XgnA=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    python3Packages.pygobject3
  ];

  pythonImportsCheck = [
    "gwebsockets"
    "gwebsockets.protocol"
    "gwebsockets.server"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WebSocket server written in Python";
    homepage = "https://github.com/sugarlabs/gwebsockets";
    license = lib.licenses.asl20;
  };
}
