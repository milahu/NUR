# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  dmenu-flexipatch = {
    pname = "dmenu-flexipatch";
    version = "a686ac9b7277ae0d5cada675f5366d4f2baaa870";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dmenu-flexipatch";
      rev = "a686ac9b7277ae0d5cada675f5366d4f2baaa870";
      fetchSubmodules = false;
      sha256 = "sha256-bDaxefEqRbXmyHQem9PSPzvXOoELpxMfvn1phiSMGGc=";
    };
    date = "2024-03-20";
  };
  dwm-flexipatch = {
    pname = "dwm-flexipatch";
    version = "dd1e34dbd63aaed8af9b34dbdd9c6ca9dd97687b";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dwm-flexipatch";
      rev = "dd1e34dbd63aaed8af9b34dbdd9c6ca9dd97687b";
      fetchSubmodules = false;
      sha256 = "sha256-B10+g3HMi22tVUu0h2fDnWNRSaf2HeGwWmyLrvI7CpA=";
    };
    date = "2024-05-04";
  };
  slock-flexipatch = {
    pname = "slock-flexipatch";
    version = "316de8856f9f25685f6f1c4e94dbf76e4f64c06b";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "slock-flexipatch";
      rev = "316de8856f9f25685f6f1c4e94dbf76e4f64c06b";
      fetchSubmodules = false;
      sha256 = "sha256-jsAfkd2Xtzp4zKwY0bExPhVtcs+OeBdGJA29SPC04jk=";
    };
    date = "2023-10-06";
  };
  st-flexipatch = {
    pname = "st-flexipatch";
    version = "aa5957495d315a2aca2a846a48ba9f7557353ec5";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "st-flexipatch";
      rev = "aa5957495d315a2aca2a846a48ba9f7557353ec5";
      fetchSubmodules = false;
      sha256 = "sha256-nkdPbxmSpdp0GuncL3Rv+EwQZgBvR+1GLueH+yartaU=";
    };
    date = "2024-05-02";
  };
}
