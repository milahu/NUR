# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  umu = {
    pname = "umu";
    version = "2d3c948a51bc1d2880a90bf985947f9afc89e8d1";
    src = fetchgit {
      url = "https://github.com/Open-Wine-Components/umu-launcher";
      rev = "2d3c948a51bc1d2880a90bf985947f9afc89e8d1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-nI9NQc7rmGARlkDJUE4jA11HHm/mFqRN5sfVExg0l5M=";
    };
    date = "2024-09-03";
  };
}
