# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  vgmtrans = {
    pname = "vgmtrans";
    version = "cb7b035c7e434a52bf5c7dc32a1d18dea607c90e";
    src = fetchgit {
      url = "https://github.com/vgmtrans/vgmtrans";
      rev = "cb7b035c7e434a52bf5c7dc32a1d18dea607c90e";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-3tod+Kl6kPDzUqinkyXIW+qaE+rgBTPOlCIMFT9vNPA=";
    };
    date = "2024-07-29";
  };
}
