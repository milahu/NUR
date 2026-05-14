{ lib
, python3
, fetchFromGitHub
}:
let
  py = python3;
in
py.pkgs.buildPythonPackage rec {
  pname = "routellm";
  version = "0.2.0-unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "lm-sys";
    repo = "RouteLLM";
    rev = "0b64fdafe049e596a3f5657c219329f24af24198";
    hash = "sha256-+jJl7YWmwRDgATasTc/QBl10XhI4tUO/HnG7hl8I5zM=";
  };

  format = "pyproject";

  postPatch = ''
    # Relax numpy version constraint - nixpkgs has numpy 2.x but routellm should work
    substituteInPlace pyproject.toml \
      --replace-fail '"numpy<2",' '"numpy",'
  '';

  propagatedBuildInputs = with py.pkgs; [
    datasets
    fastapi
    litellm
    numpy
    openai
    pandas
    pydantic
    pyyaml
    scikit-learn
    shortuuid
    torch
    tqdm
    transformers
    uvicorn
  ];

  pythonRuntimeDepsCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cat > $out/bin/routellm-server <<'SCRIPT'
    #!${py.interpreter}
    import runpy
    runpy.run_module('routellm.openai_server', run_name='__main__')
    SCRIPT
    chmod +x $out/bin/routellm-server
  '';

  meta = with lib; {
    description = "A framework for serving and evaluating LLM routers - save LLM costs without compromising quality";
    homepage = "https://github.com/lm-sys/RouteLLM";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
