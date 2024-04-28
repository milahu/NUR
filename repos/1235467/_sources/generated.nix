# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  Anime4K-rs = {
    pname = "Anime4K-rs";
    version = "a47a8ac21f81d6a3bcbdf6fc338b6546f1a51d29";
    src = fetchFromGitHub {
      owner = "andraantariksa";
      repo = "Anime4K-rs";
      rev = "a47a8ac21f81d6a3bcbdf6fc338b6546f1a51d29";
      fetchSubmodules = false;
      sha256 = "sha256-7CvYbc4U9kIwV2ELkd4lqKC1ynCwqizpXBXJamSGDig=";
    };
    date = "2020-08-09";
  };
  ab-av1 = {
    pname = "ab-av1";
    version = "6d926b25de3a222cc006d108e5d5fd21bbceb74b";
    src = fetchFromGitHub {
      owner = "alexheretic";
      repo = "ab-av1";
      rev = "6d926b25de3a222cc006d108e5d5fd21bbceb74b";
      fetchSubmodules = false;
      sha256 = "sha256-sNQoIe/OPaYBvzUkihV/STHbB9VxytTgAWUuAfj+N2I=";
    };
    date = "2024-04-04";
  };
  av1an = {
    pname = "av1an";
    version = "e69826f7c110165976ef9421290eab3759dc39b9";
    src = fetchFromGitHub {
      owner = "master-of-zen";
      repo = "av1an";
      rev = "e69826f7c110165976ef9421290eab3759dc39b9";
      fetchSubmodules = false;
      sha256 = "sha256-uvabQmV1EhYDmZm1UP0rENMTfrIs4jrYlq6AsvDfkHg=";
    };
    date = "2024-04-23";
  };
  bypy = {
    pname = "bypy";
    version = "1f72ccca44b696e9a5b66c6ec0afd58040961f0f";
    src = fetchFromGitHub {
      owner = "houtianze";
      repo = "bypy";
      rev = "1f72ccca44b696e9a5b66c6ec0afd58040961f0f";
      fetchSubmodules = false;
      sha256 = "sha256-WTvhA1jI3twxbw3WxsoRddmRvfozx9372mIjEQql07Q=";
    };
    date = "2024-03-31";
  };
  candy = {
    pname = "candy";
    version = "f84e04bbc4d2979c50df0c5f281c13e23a813dd0";
    src = fetchFromGitHub {
      owner = "lanthora";
      repo = "candy";
      rev = "f84e04bbc4d2979c50df0c5f281c13e23a813dd0";
      fetchSubmodules = false;
      sha256 = "sha256-BoPBUYEmQJ1YgyGDYDzGFaQ95QGXXVOdBYLNh5tVBjQ=";
    };
    date = "2024-04-26";
  };
  forkgram = {
    pname = "forkgram";
    version = "104166bcc86cd7dd21dfc37fd11e8c08ac25cf64";
    src = fetchFromGitHub {
      owner = "forkgram";
      repo = "tdesktop";
      rev = "104166bcc86cd7dd21dfc37fd11e8c08ac25cf64";
      fetchSubmodules = true;
      sha256 = "sha256-apJUrBXzoAFEfoT5OmXc7NPs3BnlMady3BtfTPLYnps=";
    };
    date = "2024-04-26";
  };
  hyprland = {
    pname = "hyprland";
    version = "bca7804bb6e1bf5ce5a99b9ae4806be25e36993c";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "bca7804bb6e1bf5ce5a99b9ae4806be25e36993c";
      fetchSubmodules = true;
      sha256 = "sha256-7X79xMhz19h3d/3J3i3kwTn7bQDFtPlnoCE6c7T3WWs=";
    };
    date = "2024-04-27";
  };
  hyprwayland-scanner = {
    pname = "hyprwayland-scanner";
    version = "126dad854f22fe30e6b82cd21808e76903d90ac5";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprwayland-scanner";
      rev = "126dad854f22fe30e6b82cd21808e76903d90ac5";
      fetchSubmodules = true;
      sha256 = "sha256-eaWDIvt8ufUKKz3Lc2a3PyemLJG1m9RYlF+HP3hWbaw=";
    };
    date = "2024-04-26";
  };
  idntag = {
    pname = "idntag";
    version = "0d2fcb286bfa5b7e9ec02d6d9c1d55dd2cf5da5f";
    src = fetchFromGitHub {
      owner = "d99kris";
      repo = "idntag";
      rev = "0d2fcb286bfa5b7e9ec02d6d9c1d55dd2cf5da5f";
      fetchSubmodules = false;
      sha256 = "sha256-u/WgEvGrGGfXfx/4iXLxy8mGKFsrA/nsD8CGv3MdS80=";
    };
    date = "2023-01-15";
  };
  koboldcpp = {
    pname = "koboldcpp";
    version = "593f08bb78ab6035f91cc7aa753975254f30ed82";
    src = fetchFromGitHub {
      owner = "LostRuins";
      repo = "koboldcpp";
      rev = "593f08bb78ab6035f91cc7aa753975254f30ed82";
      fetchSubmodules = true;
      sha256 = "sha256-LAAINN49gjJPye3rfbA8oh29/qcVVk99SSRZD8WQNKQ=";
    };
    date = "2024-04-20";
  };
  llamafile = {
    pname = "llamafile";
    version = "58d2ca0b7e8b2f7b8bb3e60d6edded1cacd81c80";
    src = fetchFromGitHub {
      owner = "Mozilla-Ocho";
      repo = "llamafile";
      rev = "58d2ca0b7e8b2f7b8bb3e60d6edded1cacd81c80";
      fetchSubmodules = false;
      sha256 = "sha256-kSefiL58pAevzm0fQjOzht8KwugAS/Ad8nmwAwy4YNw=";
    };
    date = "2024-04-26";
  };
  nbfc-linux = {
    pname = "nbfc-linux";
    version = "9499e16a83547306590ef3d618c45a75f9a852d0";
    src = fetchFromGitHub {
      owner = "nbfc-linux";
      repo = "nbfc-linux";
      rev = "9499e16a83547306590ef3d618c45a75f9a852d0";
      fetchSubmodules = false;
      sha256 = "sha256-zaJbaifCf632ZAK+0cVEkAlG6YU/IEwh2Uhn8tbNUFY=";
    };
    date = "2024-04-03";
  };
  ncmdump_rs = {
    pname = "ncmdump_rs";
    version = "97e6c36596773d2a34f562aed9b4d5d48499a5c6";
    src = fetchFromGitHub {
      owner = "iqiziqi";
      repo = "ncmdump.rs";
      rev = "97e6c36596773d2a34f562aed9b4d5d48499a5c6";
      fetchSubmodules = false;
      sha256 = "sha256-hvziKZlGMLndWd7+Ntheb/7Ru6hpM+QOx1iUmj4cLz4=";
    };
    date = "2023-11-10";
  };
  onedrive-fuse = {
    pname = "onedrive-fuse";
    version = "88111955b43684942407b736f34943b86ba36101";
    src = fetchFromGitHub {
      owner = "oxalica";
      repo = "onedrive-fuse";
      rev = "88111955b43684942407b736f34943b86ba36101";
      fetchSubmodules = false;
      sha256 = "sha256-JIW3/wmhaGgNXiFxj5kXJD1a1j0AeOik15t7DIeN0LU=";
    };
    date = "2024-02-12";
  };
  open-snell = {
    pname = "open-snell";
    version = "8d2645b8394b20dba744a860655e3092fc8ae052";
    src = fetchFromGitHub {
      owner = "icpz";
      repo = "open-snell";
      rev = "8d2645b8394b20dba744a860655e3092fc8ae052";
      fetchSubmodules = false;
      sha256 = "sha256-/gILrDXOXDYQ3cTUMbjHAzITdtC2O+4XO0pp1ulRAM4=";
    };
    date = "2022-04-19";
  };
  openmw = {
    pname = "openmw";
    version = "55642650eace8b990afb31abc831540a888a407c";
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "openmw";
      rev = "55642650eace8b990afb31abc831540a888a407c";
      fetchSubmodules = true;
      sha256 = "sha256-jVxQ/AHlZRdvcnYeMTAV/Al7jYGIzt9FLRbVnWJyOMo=";
    };
    date = "2024-04-26";
  };
  pot-desktop = {
    pname = "pot-desktop";
    version = "9ce1e6422fc855c8c5d34a02e01d81aaf0511fb3";
    src = fetchFromGitHub {
      owner = "pot-app";
      repo = "pot-desktop";
      rev = "9ce1e6422fc855c8c5d34a02e01d81aaf0511fb3";
      fetchSubmodules = true;
      sha256 = "sha256-Q64aZxJ+a9cmqj9xPNw2iI/hgXpUI12YA0nwfBcF4Js=";
    };
    date = "2024-04-27";
  };
  pynat = {
    pname = "pynat";
    version = "22a8f2a467bfb95003d35b139dad9fd5a1ca4e9d";
    src = fetchFromGitHub {
      owner = "aarant";
      repo = "pynat";
      rev = "22a8f2a467bfb95003d35b139dad9fd5a1ca4e9d";
      fetchSubmodules = false;
      sha256 = "sha256-2ig0mvePKglxz3IpBdiWsTfNJ9koODn34gHVRqbdwPk=";
    };
    date = "2022-08-20";
  };
  pystun3 = {
    pname = "pystun3";
    version = "681b36ce4812714449dfbf3d2f5004a2f0615240";
    src = fetchFromGitHub {
      owner = "talkiq";
      repo = "pystun3";
      rev = "681b36ce4812714449dfbf3d2f5004a2f0615240";
      fetchSubmodules = false;
      sha256 = "sha256-+SrYpAUaAXE+c34U9QGoVsk5erp/57YV79iaQx4p32Q=";
    };
    date = "2022-05-05";
  };
  qcm = {
    pname = "qcm";
    version = "a13f0b25f3915147fc3e2c80dee451ca4d039a30";
    src = fetchFromGitHub {
      owner = "hypengw";
      repo = "Qcm";
      rev = "a13f0b25f3915147fc3e2c80dee451ca4d039a30";
      fetchSubmodules = true;
      sha256 = "sha256-6NSVEyGH5yTd/Mp428lRuqDz06paQJkWGuy3ldB88X4=";
    };
    date = "2024-04-27";
  };
  reflac = {
    pname = "reflac";
    version = "a2dcaa2f5d3d23cf121934d5ff0e4d169a8f7a64";
    src = fetchFromGitHub {
      owner = "chungy";
      repo = "reflac";
      rev = "a2dcaa2f5d3d23cf121934d5ff0e4d169a8f7a64";
      fetchSubmodules = false;
      sha256 = "sha256-vrHDzDTrLPaDHXwgWJplCOQT6YdcWaEu28Rx1yXlgNk=";
    };
    date = "2021-08-16";
  };
  rescrobbled = {
    pname = "rescrobbled";
    version = "d9837ad4ddbe4f77a06c4f8a697d7d6df858e414";
    src = fetchFromGitHub {
      owner = "InputUsername";
      repo = "rescrobbled";
      rev = "d9837ad4ddbe4f77a06c4f8a697d7d6df858e414";
      fetchSubmodules = false;
      sha256 = "sha256-VOioE6BScwW2kWOViFZ84NuQ5eTI9+mBqAErGW9VWII=";
    };
    date = "2023-11-30";
  };
  sakaya = {
    pname = "sakaya";
    version = "fd3781686d01f002b802e0642c2f0eb4ef18624b";
    src = fetchFromGitHub {
      owner = "donovanglover";
      repo = "sakaya";
      rev = "fd3781686d01f002b802e0642c2f0eb4ef18624b";
      fetchSubmodules = false;
      sha256 = "sha256-QI/Hp0UuZRg/X06wH5c0w+pN0aTFnpNhgKO0gKvxrAw=";
    };
    date = "2024-04-08";
  };
  sudachi = {
    pname = "sudachi";
    version = "4ce69bc41f33e3816b9a73ecc6268bd808e44367";
    src = fetchFromGitHub {
      owner = "sudachi-emu";
      repo = "sudachi";
      rev = "4ce69bc41f33e3816b9a73ecc6268bd808e44367";
      fetchSubmodules = true;
      sha256 = "sha256-QH4eP/9w00TefqxnXkzU4nLaa0buU3Y7XUt4qWql8Ic=";
    };
    date = "2024-04-13";
  };
  suyu = {
    pname = "suyu";
    version = "dfb9f06e5c46f251e4208adf1d4861e85b1d5eea";
    src = fetchgit {
      url = "https://git.suyu.dev/suyu/suyu";
      rev = "dfb9f06e5c46f251e4208adf1d4861e85b1d5eea";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Jycpnfnx71alnxu+KgnOvaO26diEspx3O1dhA9OGflI=";
    };
    date = "2024-04-19";
  };
  sway-im = {
    pname = "sway-im";
    version = "b8434b3ad9e8c6946dbf7b14b0f7ef5679452b94";
    src = fetchgit {
      url = "https://aur.archlinux.org/sway-im";
      rev = "b8434b3ad9e8c6946dbf7b14b0f7ef5679452b94";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-/676rgCEATaaLn504c0SsShAAD6muWUuoYkc0WPGd3U=";
    };
    date = "2024-02-25";
  };
  swgp-go = {
    pname = "swgp-go";
    version = "5cd16f257127836db73efba273ff2c750794fa6b";
    src = fetchFromGitHub {
      owner = "database64128";
      repo = "swgp-go";
      rev = "5cd16f257127836db73efba273ff2c750794fa6b";
      fetchSubmodules = false;
      sha256 = "sha256-niQdJTxCv8DYKcfYqpEvcpnfW9OSExT9y18h8hib4oU=";
    };
    date = "2024-04-17";
  };
  waylyrics = {
    pname = "waylyrics";
    version = "83f20752514185a43c75a3e157c26211e2d3bf88";
    src = fetchFromGitHub {
      owner = "waylyrics";
      repo = "waylyrics";
      rev = "83f20752514185a43c75a3e157c26211e2d3bf88";
      fetchSubmodules = false;
      sha256 = "sha256-CZ2XblF+ljx9lpz2JlrsyxO/N/57xqeIrnelJR7yRsc=";
    };
    date = "2024-04-27";
  };
}
