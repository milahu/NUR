# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  propertree = {
    pname = "propertree";
    version = "79c7ccfb169f0e49457bfab6280b77e90b40e0e1";
    src = fetchgit {
      url = "https://github.com/corpnewt/ProperTree";
      rev = "79c7ccfb169f0e49457bfab6280b77e90b40e0e1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-wtMcNyjzOZkL8pUGGH+cx+Fp3+TI6fREitmjagr+c9A=";
    };
    date = "2024-08-25";
  };
}
