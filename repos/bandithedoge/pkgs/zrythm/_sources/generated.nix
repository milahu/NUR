# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  carla-git = {
    pname = "carla-git";
    version = "da911f14abbe1fcc6780e53212877686bb8103aa";
    src = fetchgit {
      url = "https://github.com/falkTX/Carla";
      rev = "da911f14abbe1fcc6780e53212877686bb8103aa";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sparseCheckout = [];
      sha256 = "sha256-u0g0YYJczGXQSdnuAbg6rYx7EnO5aNmOqzyf3eJLew8=";
    };
    date = "2024-08-11";
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
      sparseCheckout = [];
      sha256 = "sha256-4VLD29UlbrnMpk3qHBrWsoZSv4kORjbSNhGn8XF63Vw=";
    };
    date = "2024-05-28";
  };
}
