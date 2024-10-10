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
  av1an = {
    pname = "av1an";
    version = "96ee8b86bf4dc65504c52529766cd62ebabd18f7";
    src = fetchFromGitHub {
      owner = "master-of-zen";
      repo = "av1an";
      rev = "96ee8b86bf4dc65504c52529766cd62ebabd18f7";
      fetchSubmodules = false;
      sha256 = "sha256-GVUYgzpSQYNiiDwrN2Arfvq65NJsjO9kYzn/zrjJS90=";
    };
    date = "2024-10-03";
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
    version = "fbc05072fe71dc736e34329333de714a3b0b280c";
    src = fetchFromGitHub {
      owner = "lanthora";
      repo = "candy";
      rev = "fbc05072fe71dc736e34329333de714a3b0b280c";
      fetchSubmodules = false;
      sha256 = "sha256-7Q8jJS1dC4eIyl9AjmnrOwLGKe5VesLVl/dASKAaZu4=";
    };
    date = "2024-10-04";
  };
  hyprland = {
    pname = "hyprland";
    version = "bc299928ad5571300180eb8edb6742ed3bbf0282";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "Hyprland";
      rev = "bc299928ad5571300180eb8edb6742ed3bbf0282";
      fetchSubmodules = true;
      sha256 = "sha256-LuXqCRIkK41oWHd8rEj4ctLO60dYbgrXnUow9pxmVsI=";
    };
    date = "2024-10-09";
  };
  hyprwayland-scanner = {
    pname = "hyprwayland-scanner";
    version = "500c81a9e1a76760371049a8d99e008ea77aa59e";
    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "hyprwayland-scanner";
      rev = "500c81a9e1a76760371049a8d99e008ea77aa59e";
      fetchSubmodules = true;
      sha256 = "sha256-VKR0sf0PSNCB0wPHVKSAn41mCNVCnegWmgkrneKDhHM=";
    };
    date = "2024-09-21";
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
    version = "c38d1ecc8d8f4bcfe2f959584002ddf7a80b8e9b";
    src = fetchFromGitHub {
      owner = "LostRuins";
      repo = "koboldcpp";
      rev = "c38d1ecc8d8f4bcfe2f959584002ddf7a80b8e9b";
      fetchSubmodules = true;
      sha256 = "sha256-olMlYzde97RSx0OmDULSOFlM3imUq3AVxQdXyYBPd3Q=";
    };
    date = "2024-09-22";
  };
  libdrm = {
    pname = "libdrm";
    version = "c0a08f06aec84c3be102e57a56e01d639be253bb";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/mesa/drm";
      rev = "c0a08f06aec84c3be102e57a56e01d639be253bb";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-KU1Qt6gNQkT4jIwLa3nudZxuNcMZRwk9c5dlxyfvr5g=";
    };
    date = "2024-09-29";
  };
  llamafile = {
    pname = "llamafile";
    version = "f2014a8d7f07d4fbfc2021f763c73c4d0e1c1d78";
    src = fetchFromGitHub {
      owner = "Mozilla-Ocho";
      repo = "llamafile";
      rev = "f2014a8d7f07d4fbfc2021f763c73c4d0e1c1d78";
      fetchSubmodules = false;
      sha256 = "sha256-/UaRAcF/FGTWb5hXkBDtEmXeoD3EZs+NvBYW7AW556I=";
    };
    date = "2024-10-07";
  };
  nbfc-linux = {
    pname = "nbfc-linux";
    version = "2046e4cc03fdaf403767333055d88bebc117eb10";
    src = fetchFromGitHub {
      owner = "nbfc-linux";
      repo = "nbfc-linux";
      rev = "2046e4cc03fdaf403767333055d88bebc117eb10";
      fetchSubmodules = false;
      sha256 = "sha256-xcMQb20Qcn8jpcYi9A9GfgSkp8+Z6jel44UlD5ukaNA=";
    };
    date = "2024-10-08";
  };
  ncmdump_rs = {
    pname = "ncmdump_rs";
    version = "2e7f77779f55f914fb505d996b16e829028240e3";
    src = fetchFromGitHub {
      owner = "iqiziqi";
      repo = "ncmdump.rs";
      rev = "2e7f77779f55f914fb505d996b16e829028240e3";
      fetchSubmodules = false;
      sha256 = "sha256-ryxjZFTknWEGHESo0OcoBv/+rCx+rCifoSsqNUaF+FM=";
    };
    date = "2024-09-23";
  };
  onedrive-fuse = {
    pname = "onedrive-fuse";
    version = "26ceb411527a5ec59af96d5ba96ca4ed2bb149a8";
    src = fetchFromGitHub {
      owner = "oxalica";
      repo = "onedrive-fuse";
      rev = "26ceb411527a5ec59af96d5ba96ca4ed2bb149a8";
      fetchSubmodules = false;
      sha256 = "sha256-U5BzPfcV+OtzAcBYMADcK3epqWcuJeSYPQIyVl9VmPo=";
    };
    date = "2024-08-03";
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
    version = "5fdc6fa446924b575250acf853a8f7eea0c8b8c9";
    src = fetchFromGitHub {
      owner = "talkiq";
      repo = "pystun3";
      rev = "5fdc6fa446924b575250acf853a8f7eea0c8b8c9";
      fetchSubmodules = false;
      sha256 = "sha256-1QnfEHzkvjWURsApvTi4aVVz3MBNieQmVofmqUmgb4k=";
    };
    date = "2024-06-28";
  };
  qcm = {
    pname = "qcm";
    version = "6bdda8a415dc9dd62da3d9c72b7fa67bd99fad4c";
    src = fetchFromGitHub {
      owner = "hypengw";
      repo = "Qcm";
      rev = "6bdda8a415dc9dd62da3d9c72b7fa67bd99fad4c";
      fetchSubmodules = true;
      sha256 = "sha256-XvBmi+g7GxOswvWJhDryVUn0JAsy6Zi8FTf0raapiAc=";
    };
    date = "2024-10-09";
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
    version = "9c540d288f7dd1b0fd2a7058776db27d591db15a";
    src = fetchFromGitHub {
      owner = "InputUsername";
      repo = "rescrobbled";
      rev = "9c540d288f7dd1b0fd2a7058776db27d591db15a";
      fetchSubmodules = false;
      sha256 = "sha256-o5k5xk5z19oVOGE1p+t5MGQP7/YRZhqp3p786G3H7GA=";
    };
    date = "2024-08-20";
  };
  sakaya = {
    pname = "sakaya";
    version = "6d6e60253b4eba83d53b2d878b3f4447251942f5";
    src = fetchFromGitHub {
      owner = "donovanglover";
      repo = "sakaya";
      rev = "6d6e60253b4eba83d53b2d878b3f4447251942f5";
      fetchSubmodules = false;
      sha256 = "sha256-KfUBEg4kMnZFnNXpdfNggIEwmcqjYf3EdwcgkKckovw=";
    };
    date = "2024-07-22";
  };
  suyu = {
    pname = "suyu";
    version = "ee365bad9501c73ff49936e72ec91cd9c3ce5c24";
    src = fetchgit {
      url = "https://git.suyu.dev/suyu/suyu";
      rev = "ee365bad9501c73ff49936e72ec91cd9c3ce5c24";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-vw9VcSbCaG4MS0PL/fJ73CDALLbd3n0CBT7gkyp5hRc=";
    };
    date = "2024-10-06";
  };
  sway = {
    pname = "sway";
    version = "7f1cd0b73ba3290f8ee5f81fdf7f1ffa4c642ea7";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "7f1cd0b73ba3290f8ee5f81fdf7f1ffa4c642ea7";
      fetchSubmodules = true;
      sha256 = "sha256-lg7sjJmFgpemnQIYAPsnxwgBLyun/ebJigkw/J1AWXk=";
    };
    date = "2024-10-08";
  };
  swgp-go = {
    pname = "swgp-go";
    version = "4d0f4ffbe08e1b856da6063d991bc94fb16367a5";
    src = fetchFromGitHub {
      owner = "database64128";
      repo = "swgp-go";
      rev = "4d0f4ffbe08e1b856da6063d991bc94fb16367a5";
      fetchSubmodules = false;
      sha256 = "sha256-esPzo9bkkRtxcID8KBrionFxiyAL0ViqwYCSyceBkTU=";
    };
    date = "2024-10-06";
  };
  wayland = {
    pname = "wayland";
    version = "38f91fe6adb1c4e6347dc34111e17514dac4a439";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland";
      rev = "38f91fe6adb1c4e6347dc34111e17514dac4a439";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-HWKlNN4NjxX+9IF+Rw3NbBt61f5Bi13Qv7rRXtKfbgU=";
    };
    date = "2024-10-05";
  };
  wayland-protocols = {
    pname = "wayland-protocols";
    version = "ea7e5ef693e91e3005aaad90c509262c5a28d7a1";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
      rev = "ea7e5ef693e91e3005aaad90c509262c5a28d7a1";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-olDY+PB6Af/ry/gCyj30+UTdEU/EDA+XTRqS4S/bbBk=";
    };
    date = "2024-10-07";
  };
  waylyrics = {
    pname = "waylyrics";
    version = "bda74138b83ecc970093e85225167797cde58f05";
    src = fetchFromGitHub {
      owner = "waylyrics";
      repo = "waylyrics";
      rev = "bda74138b83ecc970093e85225167797cde58f05";
      fetchSubmodules = false;
      sha256 = "sha256-VnK+xCEQ4Hpxb5lcxqYKMn+cA19DpyFeFFPQezB3/VY=";
    };
    date = "2024-10-06";
  };
  wlroots = {
    pname = "wlroots";
    version = "dd8f4913a438a25201fce05efad76da62491e336";
    src = fetchgit {
      url = "https://gitlab.freedesktop.org/wlroots/wlroots";
      rev = "dd8f4913a438a25201fce05efad76da62491e336";
      fetchSubmodules = true;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-pPj2EjYWR61988ZNCITjZISXDPM1hTocumf4C3qiBQg=";
    };
    date = "2024-10-08";
  };
}
