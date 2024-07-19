# This file was generated by nvfetcher, please do not modify it manually.
{
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
}: {
  dmenu-flexipatch = {
    pname = "dmenu-flexipatch";
    version = "1c584542f4a11dda5f10f8eb84223a8beeb7cb91";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dmenu-flexipatch";
      rev = "1c584542f4a11dda5f10f8eb84223a8beeb7cb91";
      fetchSubmodules = false;
      sha256 = "sha256-RpWwkJZ8GU7sNcyAY4R05y/1eIVefxreOByqvPJp0D8=";
    };
    date = "2024-07-17";
  };
  dwm-flexipatch = {
    pname = "dwm-flexipatch";
    version = "f4258747be3215c75fbb57cc4169da6b50b02726";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "dwm-flexipatch";
      rev = "f4258747be3215c75fbb57cc4169da6b50b02726";
      fetchSubmodules = false;
      sha256 = "sha256-11rbtDosWZVcWYlG/YJDK4vIGdA7LtKFOwsxty401zE=";
    };
    date = "2024-07-14";
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
    version = "7a581fe4e15b538d3440562aa7f89d775187f250";
    src = fetchFromGitHub {
      owner = "bakkeby";
      repo = "st-flexipatch";
      rev = "7a581fe4e15b538d3440562aa7f89d775187f250";
      fetchSubmodules = false;
      sha256 = "sha256-sokLrJUBWYDg+Wc1+b5pugT4nyrTLDAqNUY4gbSe9Uk=";
    };
    date = "2024-07-07";
  };
}
