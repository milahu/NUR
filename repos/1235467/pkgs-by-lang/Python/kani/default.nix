{ lib
, python3
, fetchFromGitHub
}:
let
  py = python3;
in
py.pkgs.buildPythonApplication rec {
  pname = "kani";
  version = "unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "tumf";
    repo = "kani";
    rev = "95d640c7f6cce7d424fd472a0a051b3d31c71e53";
    hash = "sha256-pTQMt68jCS/GRJVO4JXjnrc34xvm1D3qfGGC/xpSKdY=";
  };

  postPatch = ''
    # Fix base_url version check: /v1 -> any /v\d+
    replacement="import re\n    if re.search(r\"/v\\d+\$\", base_url):"
    substituteInPlace src/kani/proxy.py \
      --replace-fail 'if base_url.endswith("/v1"):' "$(printf "$replacement")"
    # Replace uv_build with setuptools
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.10.8,<0.11.0"]' 'requires = ["setuptools"]' \
      --replace-fail 'build-backend = "uv_build"' 'build-backend = "setuptools.build_meta"'
    # Relax version constraints - nixpkgs has older versions but they likely work
    substituteInPlace pyproject.toml \
      --replace-fail '"click>=8.3.1",' '"click",' \
      --replace-fail '"fastapi>=0.135.1",' '"fastapi",' \
      --replace-fail '"httpx>=0.28.1",' '"httpx",' \
      --replace-fail '"numpy>=2.4.3",' '"numpy",' \
      --replace-fail '"openai>=2.29.0",' '"openai",' \
      --replace-fail '"platformdirs>=4.9.4",' '"platformdirs",' \
      --replace-fail '"pydantic>=2.12.5",' '"pydantic",' \
      --replace-fail '"pyyaml>=6.0.3",' '"pyyaml",' \
      --replace-fail '"scikit-learn>=1.8.0",' '"scikit-learn",' \
      --replace-fail '"tiktoken>=0.12.0",' '"tiktoken",' \
      --replace-fail '"uvicorn>=0.42.0",' '"uvicorn",'
  '';

  format = "pyproject";
  pythonRuntimeDepsCheck = false;

  nativeBuildInputs = with py.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with py.pkgs; [
    click
    fastapi
    httpx
    numpy
    openai
    platformdirs
    pydantic
    pyyaml
    scikit-learn
    tiktoken
    uvicorn
  ];

  # The package expects to find data files, let's make sure they're included
  postInstall = ''
    mkdir -p $out/share/kani
    cp -r data $out/share/kani/
    cp -r models $out/share/kani/
    cp config.example.yaml $out/share/kani/
  '';

  meta = with lib; {
    description = "LLM smart router - OpenAI API-compatible proxy that classifies prompts by complexity and routes them to optimal models";
    homepage = "https://github.com/tumf/kani";
    license = licenses.mit;
    maintainers = [ ];
  };
}
