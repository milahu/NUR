# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  cardinal = {
    pname = "cardinal";
    version = "1eec121f215b99e9e987f3a3067a15496db47a13";
    src = fetchFromGitHub {
      owner = "DISTRHO";
      repo = "Cardinal";
      rev = "1eec121f215b99e9e987f3a3067a15496db47a13";
      fetchSubmodules = true;
      sha256 = "sha256-MTV3mV3p9kQlpjqXcX7c/h+lYsugew42rF37X3245F8=";
    };
    date = "2024-08-20";
  };
}
