# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  ildaeil = {
    pname = "ildaeil";
    version = "d031a7dd54220c2447b402fe4e792782a75ead3a";
    src = fetchFromGitHub {
      owner = "DISTRHO";
      repo = "Ildaeil";
      rev = "d031a7dd54220c2447b402fe4e792782a75ead3a";
      fetchSubmodules = true;
      sha256 = "sha256-krh0lxvgw+pnxcV11sNClMapwgk7l+JJveazHLObNaQ=";
    };
    date = "2024-05-23";
  };
}
