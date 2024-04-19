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
    version = "31421df5c6f8b71fe6e3255f9570e68b99ccc2b7";
    src = fetchFromGitHub {
      owner = "master-of-zen";
      repo = "av1an";
      rev = "31421df5c6f8b71fe6e3255f9570e68b99ccc2b7";
      fetchSubmodules = false;
      sha256 = "sha256-tkNEyhgdezln+FKRsgVvl3yn4UfYznjzQ9Xi4AvEGiU=";
    };
    date = "2024-04-16";
  };
  candy = {
    pname = "candy";
    version = "7936ba78c559c60ec3633096863ffd37ec8d0e78";
    src = fetchFromGitHub {
      owner = "lanthora";
      repo = "candy";
      rev = "7936ba78c559c60ec3633096863ffd37ec8d0e78";
      fetchSubmodules = false;
      sha256 = "sha256-ekLf4v0QBRYcnAIuJ4IY8D7MGsMBZNpl/eo2+sUfDOM=";
    };
    date = "2024-04-15";
  };
  forkgram = {
    pname = "forkgram";
    version = "5efbf306d87f3f11fa8620842ee1e63d976f5499";
    src = fetchFromGitHub {
      owner = "forkgram";
      repo = "tdesktop";
      rev = "5efbf306d87f3f11fa8620842ee1e63d976f5499";
      fetchSubmodules = true;
      sha256 = "sha256-l1bAUi0npBAXXCQoF+XUPF+6bJHdFWpkmhk74S/sOhI=";
    };
    date = "2024-04-17";
  };
  hyprland = {
    pname = "hyprland";
    version = "82222342f10a7eff0ec9be972153e740d0f95213";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "82222342f10a7eff0ec9be972153e740d0f95213";
      fetchSubmodules = true;
      sha256 = "sha256-I5lVMFMtNtMhtewHMxSUJxldnecGmNczDLTGgeH7VMI=";
    };
    date = "2024-04-17";
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
    version = "2f3597c29abea8b6da28f21e714b6b24a5aca79b";
    src = fetchFromGitHub {
      owner = "LostRuins";
      repo = "koboldcpp";
      rev = "2f3597c29abea8b6da28f21e714b6b24a5aca79b";
      fetchSubmodules = true;
      sha256 = "sha256-m5bBVy740WgHLXHW7woXtzW6LS/MTrNYgYKHMwAYaZM=";
    };
    date = "2024-04-12";
  };
  llamafile = {
    pname = "llamafile";
    version = "a8124633ea9b5860712a954a7cb6d9dc4bd6b365";
    src = fetchFromGitHub {
      owner = "Mozilla-Ocho";
      repo = "llamafile";
      rev = "a8124633ea9b5860712a954a7cb6d9dc4bd6b365";
      fetchSubmodules = false;
      sha256 = "sha256-G/TDypt5BB+3juleVsSLPMmoOQvNvfEKKONCCs8oTeI=";
    };
    date = "2024-04-12";
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
    version = "e4c70b7861ccc65915e864e6aedb4887302aa733";
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "openmw";
      rev = "e4c70b7861ccc65915e864e6aedb4887302aa733";
      fetchSubmodules = true;
      sha256 = "sha256-WMdQfTleYP/1L619JiSo6+hM7RH+climgq0i4a5s8Ys=";
    };
    date = "2024-04-17";
  };
  pot-desktop = {
    pname = "pot-desktop";
    version = "1207bf24946a1250ea3694045248fe512ebf46ea";
    src = fetchFromGitHub {
      owner = "pot-app";
      repo = "pot-desktop";
      rev = "1207bf24946a1250ea3694045248fe512ebf46ea";
      fetchSubmodules = true;
      sha256 = "sha256-9mWgp8V6qVA+SGnXLioe39y3UIMNnE0KC5N14N+iZ/w=";
    };
    date = "2024-04-17";
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
    version = "ab29b2cd7a4bc554be2d8dc8401e5dfd7df2c6c6";
    src = fetchFromGitHub {
      owner = "hypengw";
      repo = "Qcm";
      rev = "ab29b2cd7a4bc554be2d8dc8401e5dfd7df2c6c6";
      fetchSubmodules = true;
      sha256 = "sha256-uJwreBXSSH6uXd14e3Ln2rHvk+rrOvmUtkeRIU3sOSw=";
    };
    date = "2024-02-25";
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
    version = "91db3e88e5329cb3dda250e0827f26ace810abab";
    src = fetchgit {
      url = "https://git.suyu.dev/suyu/suyu";
      rev = "91db3e88e5329cb3dda250e0827f26ace810abab";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-JPO11UkBbf5WsIfsoZyOVP8n8jI2H3HF4kSVtkIplp0=";
    };
    date = "2024-04-18";
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
    version = "206b90229f8e2798f78652c5b4c27220aece34a9";
    src = fetchFromGitHub {
      owner = "waylyrics";
      repo = "waylyrics";
      rev = "206b90229f8e2798f78652c5b4c27220aece34a9";
      fetchSubmodules = false;
      sha256 = "sha256-XKuwVo6q/M/QoZg4xH3wVacM1zn4OF6vpu8eiP0730E=";
    };
    date = "2024-04-17";
  };
}
