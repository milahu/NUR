# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  carla-git = {
    pname = "carla-git";
    version = "c37d53a4216654118e711fa41e88e7e801d5bd9b";
    src = fetchFromGitHub {
      owner = "falkTX";
      repo = "Carla";
      rev = "c37d53a4216654118e711fa41e88e7e801d5bd9b";
      fetchSubmodules = false;
      sha256 = "sha256-nduM04HVZVNVCDsIIp/vcwL13Io5RgZaWRi+CfDbFwk=";
    };
    date = "2024-05-24";
  };
  zrythm = {
    pname = "zrythm";
    version = "ac5cfedd7e3b4f8c41e99b8fad8fa1a422189495";
    src = fetchgit {
      url = "https://gitlab.zrythm.org/zrythm/zrythm.git";
      rev = "ac5cfedd7e3b4f8c41e99b8fad8fa1a422189495";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-p/t/EEyQ7L2vodg7EvWbdeKi9NxiqVllNvyyZoMRS2c=";
    };
    date = "2024-05-26";
  };
}
