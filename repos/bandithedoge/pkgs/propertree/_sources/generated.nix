# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  propertree = {
    pname = "propertree";
    version = "4807f2580bed1a6db207c9b3e75e8cdc817b50ad";
    src = fetchgit {
      url = "https://github.com/corpnewt/ProperTree";
      rev = "4807f2580bed1a6db207c9b3e75e8cdc817b50ad";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-VmwI+Cria0gzFnLedCUyQLn7OvluslQ8Brngkde9Y+Q=";
    };
    date = "2024-06-18";
  };
}
