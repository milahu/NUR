{
  lib,
  python3Packages,
  fetchFromGitHub,
  rio-cogeo,
  server-thread,
}:

python3Packages.buildPythonApplication rec {
  pname = "localtileserver";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "banesullivan";
    repo = "localtileserver";
    rev = "v${version}";
    hash = "sha256-CD8NNNUbF3b+UDc+TfcGJn3EHy7b5k7FxYGB5UpzsG8=";
  };

  dependencies = with python3Packages; [
    click
    flask
    flask-caching
    flask-cors
    flask-restx
    rio-tiler
    rio-cogeo
    requests
    server-thread
    setuptools
    scooby
    werkzeug
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTests = [
    "test_create_tile_client"
    "test_is_valid_palette_name"
    "test_home_page_with_file"
    "test_home_page"
    "test_cesium_split_view"
    "test_style"
    "test_cog_validate_endpoint"
    "test_get_pine_gulch"
    "test_get_oam2"
    "test_cog_validate"
    "test_tileclient_with_vsi"
  ];

  meta = {
    description = "Local Tile Server for Geospatial Rasters";
    homepage = "https://localtileserver.banesullivan.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sikmir ];
  };
}
