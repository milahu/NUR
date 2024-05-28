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
    version = "1792598e05da73f70192c85b7969999735aa22c6";
    src = fetchgit {
      url = "https://gitlab.zrythm.org/zrythm/zrythm.git";
      rev = "1792598e05da73f70192c85b7969999735aa22c6";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-4VLD29UlbrnMpk3qHBrWsoZSv4kORjbSNhGn8XF63Vw=";
    };
    date = "2024-05-28";
  };
}
