# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  hvcc = {
    pname = "hvcc";
    version = "v0.12.1";
    src = fetchFromGitHub {
      owner = "Wasted-Audio";
      repo = "hvcc";
      rev = "v0.12.1";
      fetchSubmodules = false;
      sha256 = "sha256-Ir4jqBSnrb+GdhCEw62fGPzgluZVX8Z0VQ0tadhFnpY=";
    };
  };
  wstd2daisy = {
    pname = "wstd2daisy";
    version = "71e2982454d3410c5e4479c2d0dfa575a9826d17";
    src = fetchgit {
      url = "https://github.com/Wasted-Audio/json2daisy";
      rev = "71e2982454d3410c5e4479c2d0dfa575a9826d17";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-1QKYx9gocAKKWCP9uEmuhtFWCptCd+vBlga5keBxkzY=";
    };
    date = "2024-09-20";
  };
}