# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  cardinal = {
    pname = "cardinal";
    version = "6bb87fd55239878b0e0880e0b0aac18f2e35c845";
    src = fetchFromGitHub {
      owner = "DISTRHO";
      repo = "Cardinal";
      rev = "6bb87fd55239878b0e0880e0b0aac18f2e35c845";
      fetchSubmodules = true;
      sha256 = "sha256-W4leMPurIe++XTyxMf/0/KIpKfCWg5CMERoPPOMvaKE=";
    };
    date = "2024-07-29";
  };
}
