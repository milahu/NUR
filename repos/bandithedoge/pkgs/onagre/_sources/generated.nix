# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  onagre = {
    pname = "onagre";
    version = "543f1fe827f4b16408cdcc07c19fb839741ca0f5";
    src = fetchurl {
      url = "https://github.com/onagre-launcher/onagre/archive/543f1fe827f4b16408cdcc07c19fb839741ca0f5.tar.gz";
      sha256 = "sha256-s4Mysu+w9PoCIliRB6dZ+5YhrB1wgVmpaIeJwO4oIPA=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./onagre-543f1fe827f4b16408cdcc07c19fb839741ca0f5/Cargo.lock;
      outputHashes = {
      };
    };
    date = "2024-04-18";
  };
}