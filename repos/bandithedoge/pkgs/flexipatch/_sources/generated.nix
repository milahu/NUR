# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  dmenu-flexipatch = {
    pname = "dmenu-flexipatch";
    version = "9ef1b3c317d6395ac7fd2c6951d356e9990ce23d";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dmenu-flexipatch";
      rev = "9ef1b3c317d6395ac7fd2c6951d356e9990ce23d";
      fetchSubmodules = false;
      sha256 = "sha256-2mr+qT6CZJohMG05itxp63eCNfZEJqKD4BLp/GP5ZCA=";
    };
    date = "2024-05-17";
  };
  dwm-flexipatch = {
    pname = "dwm-flexipatch";
    version = "66770cfbccceb562279ad7f8c700622b42776281";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dwm-flexipatch";
      rev = "66770cfbccceb562279ad7f8c700622b42776281";
      fetchSubmodules = false;
      sha256 = "sha256-IopL1retKUursdN1SXt7FA60a45Bg70KoyAP8KUKzYo=";
    };
    date = "2024-05-17";
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
    version = "8aee31444abb1a8af50c54c802ff0af0054388b7";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "st-flexipatch";
      rev = "8aee31444abb1a8af50c54c802ff0af0054388b7";
      fetchSubmodules = false;
      sha256 = "sha256-pbE0DYVKCzxTMmZc6SxCMyn/Y9BQPHDSxZiI699EiKE=";
    };
    date = "2024-05-31";
  };
}
