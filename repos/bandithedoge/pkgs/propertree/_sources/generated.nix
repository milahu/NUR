# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  propertree = {
    pname = "propertree";
    version = "f7fd5ff91cde5445d04fcd1e160a73362b050d76";
    src = fetchgit {
      url = "https://github.com/corpnewt/ProperTree";
      rev = "f7fd5ff91cde5445d04fcd1e160a73362b050d76";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-O8MjmGRsMB4vDANgQ+/n4Vc8hl/zaRrBJ32V0DlgOX0=";
    };
    date = "2024-05-10";
  };
}