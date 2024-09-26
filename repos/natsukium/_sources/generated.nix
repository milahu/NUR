# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  copyq-darwin = {
    pname = "copyq-darwin";
    version = "9.0.0";
    src = fetchurl {
      url = "https://github.com/hluk/CopyQ/releases/download/v9.0.0/CopyQ-macos-12-m1.dmg.zip";
      sha256 = "sha256-ABLYjG2OW6wpMI7uXudkM8MYEQBRbxbGcBm2iiuN/0w=";
    };
  };
  emacs-plus = {
    pname = "emacs-plus";
    version = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
    src = fetchFromGitHub {
      owner = "d12frosted";
      repo = "homebrew-emacs-plus";
      rev = "cc3280dfdf7562dd69c97d0dfa872b1c3313a18a";
      fetchSubmodules = false;
      sha256 = "sha256-Twamd/Doh2btEix3TK/NfilT5eZ6jEJ9rBXbJeVb6Yw=";
    };
    date = "2024-09-17";
  };
  nixpkgs-review = {
    pname = "nixpkgs-review";
    version = "c012c3ebc4aa63dd47be1bf0063e8cf0949bc294";
    src = fetchFromGitHub {
      owner = "natsukium";
      repo = "nixpkgs-review";
      rev = "c012c3ebc4aa63dd47be1bf0063e8cf0949bc294";
      fetchSubmodules = false;
      sha256 = "sha256-Bzut7cuOHPrgvNSa2USZEuln8glMjKwhXyEoi5lSKZ8=";
    };
    date = "2024-09-23";
  };
  qmk-toolbox = {
    pname = "qmk-toolbox";
    version = "0.3.3";
    src = fetchurl {
      url = "https://github.com/qmk/qmk_toolbox/releases/download/0.3.3/QMK.Toolbox.app.zip";
      sha256 = "sha256-WPre2csGAQzavtksLbj3L/MrWUT6d2gTJVq7eAmpcLk=";
    };
  };
  qutebrowser-darwin = {
    pname = "qutebrowser-darwin";
    version = "3.2.1";
    src = fetchurl {
      url = "https://github.com/qutebrowser/qutebrowser/releases/download/v3.2.1/qutebrowser-3.2.1-arm64.dmg";
      sha256 = "sha256-HNEXLXy1rgHiD97JyOEuBuZAeGjge1wvHgo9esZZKCY=";
    };
  };
  sbarlua = {
    pname = "sbarlua";
    version = "29395b1928835efa1b376d438216fbf39e0d0f83";
    src = fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SbarLua";
      rev = "29395b1928835efa1b376d438216fbf39e0d0f83";
      fetchSubmodules = false;
      sha256 = "sha256-C2tg1mypz/CdUmRJ4vloPckYfZrwHxc4v8hsEow4RZs=";
    };
    date = "2024-02-28";
  };
  skkeleton = {
    pname = "skkeleton";
    version = "1035184420cfff705770a5b04aabe0ed0acb4db8";
    src = fetchFromGitHub {
      owner = "vim-skk";
      repo = "skkeleton";
      rev = "1035184420cfff705770a5b04aabe0ed0acb4db8";
      fetchSubmodules = false;
      sha256 = "sha256-u1Bd/tNpftheBkIRunu29h3VWISGcu38dbRdui8WRqc=";
    };
    date = "2024-09-20";
  };
  vivaldi-darwin = {
    pname = "vivaldi-darwin";
    version = "6.9.3447.48";
    src = fetchurl {
      url = "https://downloads.vivaldi.com/stable/Vivaldi.6.9.3447.48.universal.dmg";
      sha256 = "sha256-i03y0gseEl9bZw2NYUW6x78XNME1TTEtIi/QnNgL5Po=";
    };
  };
}
