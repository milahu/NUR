# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  vgmtrans = {
    pname = "vgmtrans";
    version = "8de8ad7701c03a171365ac8ec0b7a2bcde88cea3";
    src = fetchgit {
      url = "https://github.com/vgmtrans/vgmtrans";
      rev = "8de8ad7701c03a171365ac8ec0b7a2bcde88cea3";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-E7oS79NCDgeEbd7RKmf3kdUNlRv2B1enyh3Bu3IUDJA=";
    };
    date = "2024-08-27";
  };
}
