# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  satty = {
    pname = "satty";
    version = "d2e3137667c9b8f1e5a5777be831a5b6acbfc31b";
    src = fetchFromGitHub {
      owner = "gabm";
      repo = "Satty";
      rev = "d2e3137667c9b8f1e5a5777be831a5b6acbfc31b";
      fetchSubmodules = false;
      sha256 = "sha256-4upjVP7DEWD76wycmCQxl86nsJYI0+V7dSThRFJu9Ds=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./satty-d2e3137667c9b8f1e5a5777be831a5b6acbfc31b/Cargo.lock;
      outputHashes = {
      };
    };
    date = "2024-05-30";
  };
}
