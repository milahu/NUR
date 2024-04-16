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
    version = "f34fad88581ab3f30883bf0e35beb674ed50a33e";
    src = fetchFromGitHub {
      owner = "master-of-zen";
      repo = "av1an";
      rev = "f34fad88581ab3f30883bf0e35beb674ed50a33e";
      fetchSubmodules = false;
      sha256 = "sha256-21WK2GOzUO6JBvXzo4CYA+717lF6fpEEagIFK80GQJ8=";
    };
    date = "2024-04-06";
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
    version = "20350dc2468a94a4affc7483ed850eb100080d33";
    src = fetchFromGitHub {
      owner = "forkgram";
      repo = "tdesktop";
      rev = "20350dc2468a94a4affc7483ed850eb100080d33";
      fetchSubmodules = true;
      sha256 = "sha256-YsuECMS0HAPdw94X5pSFDj+iFuzjEnqE1oCosPQ9jC4=";
    };
    date = "2024-04-15";
  };
  hyprland = {
    pname = "hyprland";
    version = "79a139c9495568f69dd995bce1ca579247a98a17";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "79a139c9495568f69dd995bce1ca579247a98a17";
      fetchSubmodules = true;
      sha256 = "sha256-GXeN6esnjUns181YmLN45FamJHEyFSJ3wOZ0BYkJztI=";
    };
    date = "2024-04-15";
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
    version = "819aace8915860fe76a91a748a6112bc2582ba78";
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "openmw";
      rev = "819aace8915860fe76a91a748a6112bc2582ba78";
      fetchSubmodules = true;
      sha256 = "sha256-0U/vVNU7Lo9T/XprJjeufrqbKz/6Lmw+ume/0kGRH6I=";
    };
    date = "2024-04-15";
  };
  pot-desktop = {
    pname = "pot-desktop";
    version = "63e2012503af7254c1b2e662155ef4c56013b66d";
    src = fetchFromGitHub {
      owner = "pot-app";
      repo = "pot-desktop";
      rev = "63e2012503af7254c1b2e662155ef4c56013b66d";
      fetchSubmodules = true;
      sha256 = "sha256-xfcy6CtzrKMbdiFyjFuaXTkU/aqJkwQzCWzKhr04Dl4=";
    };
    date = "2024-04-14";
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
    version = "88ac3ad34418b75c2163785328d04944f2e0d014";
    src = fetchgit {
      url = "https://git.suyu.dev/suyu/suyu";
      rev = "88ac3ad34418b75c2163785328d04944f2e0d014";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-uEskLB+zKQ0SsOyzC1pB8QVjcIFiGuPJ1XBLAFTQgKY=";
    };
    date = "2024-04-15";
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
    version = "9031aca6bb3338c2316c9195d5f5fb5c2d706d9c";
    src = fetchFromGitHub {
      owner = "database64128";
      repo = "swgp-go";
      rev = "9031aca6bb3338c2316c9195d5f5fb5c2d706d9c";
      fetchSubmodules = false;
      sha256 = "sha256-GiJD2DhRIRTaGSMCf56ktlb46tgjEogINg60S2trxis=";
    };
    date = "2024-04-04";
  };
  waylyrics = {
    pname = "waylyrics";
    version = "c590d4d4ca5638791021e7c32968b82921a80d54";
    src = fetchFromGitHub {
      owner = "waylyrics";
      repo = "waylyrics";
      rev = "c590d4d4ca5638791021e7c32968b82921a80d54";
      fetchSubmodules = false;
      sha256 = "sha256-u2YAmuChD+2J7dNoHAsNM7XKP9gRV25Ef35qr0XI2Dg=";
    };
    date = "2024-04-16";
  };
}