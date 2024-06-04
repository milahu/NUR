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
    version = "ecd0da5f37f3535c9eb78ce9771590fa54de3108";
    src = fetchFromGitHub {
      owner = "alexheretic";
      repo = "ab-av1";
      rev = "ecd0da5f37f3535c9eb78ce9771590fa54de3108";
      fetchSubmodules = false;
      sha256 = "sha256-uui1pG5WUaHpLFRwj/pa46X+Z4v1ci2pZQuV6R3gkyE=";
    };
    date = "2024-05-25";
  };
  av1an = {
    pname = "av1an";
    version = "5184c0504e7d7af9a2a564558d9bf0c9bfd0474d";
    src = fetchFromGitHub {
      owner = "master-of-zen";
      repo = "av1an";
      rev = "5184c0504e7d7af9a2a564558d9bf0c9bfd0474d";
      fetchSubmodules = false;
      sha256 = "sha256-HYVF50mjDDtAGX71qgPPGT2Jwg6kfG45eJC2WWfZ2ek=";
    };
    date = "2024-05-27";
  };
  bypy = {
    pname = "bypy";
    version = "9e1530725f93d941d82596895d6fc36738f72f1c";
    src = fetchFromGitHub {
      owner = "houtianze";
      repo = "bypy";
      rev = "9e1530725f93d941d82596895d6fc36738f72f1c";
      fetchSubmodules = false;
      sha256 = "sha256-dZclceNcTVrjzm5VSvQz088q2M46zMImk8BA7/iIYUk=";
    };
    date = "2024-05-02";
  };
  candy = {
    pname = "candy";
    version = "760574523e535ec37d47515d72cc7a688b061e91";
    src = fetchFromGitHub {
      owner = "lanthora";
      repo = "candy";
      rev = "760574523e535ec37d47515d72cc7a688b061e91";
      fetchSubmodules = false;
      sha256 = "sha256-MgWbMxgYUrr4x6ostiQl5sko20A80P/MqvuK+k9ow1c=";
    };
    date = "2024-05-27";
  };
  forkgram = {
    pname = "forkgram";
    version = "0fc248177ccb6ca204ef38f34eb2d0b5e978d00e";
    src = fetchFromGitHub {
      owner = "forkgram";
      repo = "tdesktop";
      rev = "0fc248177ccb6ca204ef38f34eb2d0b5e978d00e";
      fetchSubmodules = true;
      sha256 = "sha256-Y6zahPdnZy2IZ4ifzs/sgcTolWfYCBruqQYMyyKMXzA=";
    };
    date = "2024-06-02";
  };
  hyprland = {
    pname = "hyprland";
    version = "358e59e69d27a69381bc0872b5b8d1184bc6b6a1";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "358e59e69d27a69381bc0872b5b8d1184bc6b6a1";
      fetchSubmodules = true;
      sha256 = "sha256-EnkKVUYqVfYqJso4t8ScuuMNEge7eybpdvtPCy4uwlc=";
    };
    date = "2024-06-02";
  };
  hyprwayland-scanner = {
    pname = "hyprwayland-scanner";
    version = "b06c0b8e56bd73c42218148efd8600c5e9fd6619";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprwayland-scanner";
      rev = "b06c0b8e56bd73c42218148efd8600c5e9fd6619";
      fetchSubmodules = true;
      sha256 = "sha256-hRE0+vPXQYB37nx07HQMnaCV5wJjShOeqRygw3Ga6WM=";
    };
    date = "2024-06-01";
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
    version = "318d5b87fc1602ef16d8271bfdd937ef416a8182";
    src = fetchFromGitHub {
      owner = "LostRuins";
      repo = "koboldcpp";
      rev = "318d5b87fc1602ef16d8271bfdd937ef416a8182";
      fetchSubmodules = true;
      sha256 = "sha256-Fc0Vf01X7umo1R3eFlEEs46+IqbSq6XI74dqihDZqj8=";
    };
    date = "2024-05-25";
  };
  libdrm = {
    pname = "libdrm";
    version = "7f20912b1be52ec65bc917dcd27515e905f9f567";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/mesa/drm";
      rev = "7f20912b1be52ec65bc917dcd27515e905f9f567";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-YkVGieKY+apaXLZ8wSCnCfeGk+PBzuHq3Z2M1KoxFlE=";
    };
    date = "2024-06-02";
  };
  llamafile = {
    pname = "llamafile";
    version = "9cd8d70942a049ba3c3bddd12e87e1fb599fbd49";
    src = fetchFromGitHub {
      owner = "Mozilla-Ocho";
      repo = "llamafile";
      rev = "9cd8d70942a049ba3c3bddd12e87e1fb599fbd49";
      fetchSubmodules = false;
      sha256 = "sha256-8rbIhLNqQLjpKDOVlJFhHAEKN5W8X/6DHHLI3eTALIA=";
    };
    date = "2024-06-01";
  };
  nbfc-linux = {
    pname = "nbfc-linux";
    version = "c3d7d8c7368ccb7514d92787cf1817d049288a7e";
    src = fetchFromGitHub {
      owner = "nbfc-linux";
      repo = "nbfc-linux";
      rev = "c3d7d8c7368ccb7514d92787cf1817d049288a7e";
      fetchSubmodules = false;
      sha256 = "sha256-5zXEdLKT3MU49XgXQ9mLnKZKmPi2+OJvTlYx/bTSmts=";
    };
    date = "2024-06-02";
  };
  ncmdump_rs = {
    pname = "ncmdump_rs";
    version = "69952f6a5a4a14ac5c4767fa0600cd391343d1b3";
    src = fetchFromGitHub {
      owner = "iqiziqi";
      repo = "ncmdump.rs";
      rev = "69952f6a5a4a14ac5c4767fa0600cd391343d1b3";
      fetchSubmodules = false;
      sha256 = "sha256-6WLqrcZsDorFQFIjbEitTdAcI2twqbvHdQU/Thar09Y=";
    };
    date = "2024-05-28";
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
    version = "05815b39527e41f820f8d24895e4fa1e82bb753c";
    src = fetchFromGitHub {
      owner = "OpenMW";
      repo = "openmw";
      rev = "05815b39527e41f820f8d24895e4fa1e82bb753c";
      fetchSubmodules = true;
      sha256 = "sha256-UtG7oXWtF1PDKUGCScO3GUH2SKGTQsX6MpvQp1Nnlg0=";
    };
    date = "2024-06-01";
  };
  portkey = {
    pname = "portkey";
    version = "v1.3.0";
    src = fetchFromGitHub {
      owner = "Portkey-AI";
      repo = "gateway";
      rev = "v1.3.0";
      fetchSubmodules = false;
      sha256 = "sha256-bK1hQ+mCS7ydSJWrVOIwE2IcqB3JO8avKd6wu0V8GYs=";
    };
  };
  pot-desktop = {
    pname = "pot-desktop";
    version = "8a376535dea6464709b5f48e3743014c5905f9ea";
    src = fetchFromGitHub {
      owner = "pot-app";
      repo = "pot-desktop";
      rev = "8a376535dea6464709b5f48e3743014c5905f9ea";
      fetchSubmodules = true;
      sha256 = "sha256-IoiQs9MJY8moCyk/RPXuMJDm5HSnKaZ6MWDlX22Z6lk=";
    };
    date = "2024-05-07";
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
    version = "5887fb90d6ddcdc08c1b2fc505f8e2c3e578d54e";
    src = fetchFromGitHub {
      owner = "hypengw";
      repo = "Qcm";
      rev = "5887fb90d6ddcdc08c1b2fc505f8e2c3e578d54e";
      fetchSubmodules = true;
      sha256 = "sha256-9xbAw5U4BtpupelsOzfZGosdLx06TKPTG8hhc/no3R0=";
    };
    date = "2024-05-29";
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
    version = "848c0485300b5c62f0fd360701b26c3219e4f339";
    src = fetchFromGitHub {
      owner = "donovanglover";
      repo = "sakaya";
      rev = "848c0485300b5c62f0fd360701b26c3219e4f339";
      fetchSubmodules = false;
      sha256 = "sha256-2W5oYJLusTxBztQ9FyyxvM7HM/XxjRs0qe4mhNeBfR8=";
    };
    date = "2024-05-12";
  };
  sudachi = {
    pname = "sudachi";
    version = "50ad68316dd1fdd7a4d00be3022241eebfd8d4b9";
    src = fetchFromGitHub {
      owner = "sudachi-emu";
      repo = "sudachi";
      rev = "50ad68316dd1fdd7a4d00be3022241eebfd8d4b9";
      fetchSubmodules = true;
      sha256 = "sha256-ZjOvUesthXFssaqnNBC0TBN/lHd9qkalOCGYg7dpEhU=";
    };
    date = "2024-06-01";
  };
  suyu = {
    pname = "suyu";
    version = "daf2c1f49658ebe88d9038baf35d4e3c3703a454";
    src = fetchgit {
      url = "https://git.suyu.dev/suyu/suyu";
      rev = "daf2c1f49658ebe88d9038baf35d4e3c3703a454";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-hQfb6cVSSKiw79RxerKJis1OTS6J/wEaIFg4h/R416M=";
    };
    date = "2024-05-29";
  };
  sway = {
    pname = "sway";
    version = "2e9139df664f1e2dbe14b5df4a9646411b924c66";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "2e9139df664f1e2dbe14b5df4a9646411b924c66";
      fetchSubmodules = true;
      sha256 = "sha256-gixghza8zR65xZRV1IZJTQyLbfiYv63sgd6kf1TkVoc=";
    };
    date = "2024-05-28";
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
  sway-im-git = {
    pname = "sway-im-git";
    version = "98296b9bc6f5ff1fb9c127d3b50ffbca96698f02";
    src = fetchgit {
      url = "https://aur.archlinux.org/sway-im-git";
      rev = "98296b9bc6f5ff1fb9c127d3b50ffbca96698f02";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-BsUeeo6mYpoTiE9zjqElbkKl2tuCb6PCVm1L6WGbz/Y=";
    };
    date = "2024-02-20";
  };
  swgp-go = {
    pname = "swgp-go";
    version = "374f3eb84838cfbbb910398900d555738b85f4bb";
    src = fetchFromGitHub {
      owner = "database64128";
      repo = "swgp-go";
      rev = "374f3eb84838cfbbb910398900d555738b85f4bb";
      fetchSubmodules = false;
      sha256 = "sha256-NUk5Nb6hU9jdhvgl9ph90rN0O4DY7vE5IyTYxYGtDs4=";
    };
    date = "2024-05-20";
  };
  wayland = {
    pname = "wayland";
    version = "1d5772b7b9d0bbfbc27557721f62a9f805b66929";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland";
      rev = "1d5772b7b9d0bbfbc27557721f62a9f805b66929";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-gq7ytLQiRdERz1JUjwg1+UrgYDMsMwooKlbx/7aqgkg=";
    };
    date = "2024-05-30";
  };
  wayland-protocols = {
    pname = "wayland-protocols";
    version = "1c36a3f3ca2dbc653d1f4c59ef68495199f827e6";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
      rev = "1c36a3f3ca2dbc653d1f4c59ef68495199f827e6";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-mWdlwHx0AYRlnLCTtC1qtkH19R8dTjhmBj8k7ZpEqio=";
    };
    date = "2024-05-30";
  };
  waylyrics = {
    pname = "waylyrics";
    version = "50c963cc9c66a1f69c1b7094aa17d22f3c5d1388";
    src = fetchFromGitHub {
      owner = "waylyrics";
      repo = "waylyrics";
      rev = "50c963cc9c66a1f69c1b7094aa17d22f3c5d1388";
      fetchSubmodules = false;
      sha256 = "sha256-f05Xyc1cPJ19MW2OZGiXKFCdREMOiph3EvYhfBbykGE=";
    };
    date = "2024-06-02";
  };
  wlroots = {
    pname = "wlroots";
    version = "95ac3e99242b4e7f59f00dd073ede405ff8e9e26";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wlroots/wlroots";
      rev = "95ac3e99242b4e7f59f00dd073ede405ff8e9e26";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-Cqv/5kW5TYsAzvhrHIGyTTYcQGmKKYOO9liDnbNEAFg=";
    };
    date = "2024-05-31";
  };
}
