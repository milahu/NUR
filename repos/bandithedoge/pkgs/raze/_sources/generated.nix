# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  raze = {
    pname = "raze";
    version = "1.10.2";
    src = fetchFromGitHub {
      owner = "ZDoom";
      repo = "Raze";
      rev = "1.10.2";
      fetchSubmodules = false;
      sha256 = "sha256-8kr+BLwfTQ0kx6TMqu1AUxiCgvwJd2urZqJ09FH48lo=";
    };
  };
  zmusic = {
    pname = "zmusic";
    version = "50ad730c381ce01a01a693e9e1d43e80c34eaeed";
    src = fetchgit {
      url = "https://github.com/ZDoom/ZMusic";
      rev = "50ad730c381ce01a01a693e9e1d43e80c34eaeed";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-rvvMS5KciHEvoY4hSfgAEyWJiDMqBto4o09oIpQIGTQ=";
    };
    date = "2024-04-28";
  };
}
