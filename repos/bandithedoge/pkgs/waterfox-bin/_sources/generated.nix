# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  waterfox-bin = {
    pname = "waterfox-bin";
    version = "G6.0.18";
    src = fetchurl {
      url = "https://cdn1.waterfox.net/waterfox/releases/G6.0.18/Linux_x86_64/waterfox-G6.0.18.tar.bz2";
      sha256 = "sha256-W1jWD6RvoqMjCinvRJ4MQbTPrD5ZxILrzL+pOGmTqpA=";
    };
  };
}
