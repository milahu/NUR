{ lib, python3Packages, fetchFromGitHub, callPackage }:
let
  sources = callPackage ../../../_sources/generated.nix { };
in
with python3Packages;
buildPythonApplication rec {
  pname = "LinguaGacha";
  version = "0.26.1";
  src = fetchFromGitHub {
    owner = "neavo";
    repo = "LinguaGacha";
    rev = "MANUAL_BUILD_v0.26.1";
    sha256 = "sha256-R3nzh6kiRgpT5wxoohuXrAtnBgT7DeerE11+eYL04Lc=";
  };
  propagatedBuildInputs = with python3Packages; [
    #PyQt-Fluent-Widgets[full]
    openai
    anthropic
    google-genai
    tiktoken
    openpyxl
    lxml
    beautifulsoup4

    # Tools
    rich
    tqdm
    httpx
    json-repair
    charset-normalizer
  ] ++ (with pkgs; [ opencc ]);
  doCheck = false;
}
