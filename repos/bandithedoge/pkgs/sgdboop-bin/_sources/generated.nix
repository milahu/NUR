# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  sgdboop-bin = {
    pname = "sgdboop-bin";
    version = "v1.2.8";
    src = fetchurl {
      url = "https://github.com/SteamGridDB/SGDBoop/releases/download/v1.2.8/sgdboop-linux64.tar.gz";
      sha256 = "sha256-LrP0qFg4kOhAicWtORfnW3TvIegvcJf/GiYTHcOeJK4=";
    };
  };
}