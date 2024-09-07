# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  autotools-language-server = {
    pname = "autotools-language-server";
    version = "0.0.20";
    src = fetchurl {
      url = "https://pypi.org/packages/source/a/autotools_language_server/autotools_language_server-0.0.20.tar.gz";
      sha256 = "sha256-W/jUooAl7WPI2+KVJqoHpAF70iUynrr2NdhyickpyE4=";
    };
  };
  expect-language-server = {
    pname = "expect-language-server";
    version = "0.0.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/e/expect-language-server/expect-language-server-0.0.1.tar.gz";
      sha256 = "sha256-7L2h91ZpB+VhUlP5kOa4lpKzr8LnkjXcP8I45M9Lrgk=";
    };
  };
  lsp-tree-sitter = {
    pname = "lsp-tree-sitter";
    version = "0.0.16";
    src = fetchurl {
      url = "https://pypi.org/packages/source/l/lsp_tree_sitter/lsp_tree_sitter-0.0.16.tar.gz";
      sha256 = "sha256-bhHWZintMbTIKe6HpmaUaKapUrnoS1bliYI05qWZz2I=";
    };
  };
  manpager = {
    pname = "manpager";
    version = "0.0.3";
    src = fetchFromGitHub {
      owner = "Freed-Wu";
      repo = "manpager";
      rev = "0.0.3";
      fetchSubmodules = false;
      sha256 = "sha256-oqAgY/9qZ2d8p74qqFEM2VxT9ohV3CR8bcBCbyHlcOo=";
    };
  };
  mulimgviewer = {
    pname = "mulimgviewer";
    version = "3.9.10";
    src = fetchurl {
      url = "https://pypi.org/packages/source/m/mulimgviewer/mulimgviewer-3.9.10.tar.gz";
      sha256 = "sha256-srBgon7/yrbvV6m0Em67iiA1KLo6b2QTJjN786bZIck=";
    };
  };
  mutt-language-server = {
    pname = "mutt-language-server";
    version = "0.0.11";
    src = fetchurl {
      url = "https://pypi.org/packages/source/m/mutt_language_server/mutt_language_server-0.0.11.tar.gz";
      sha256 = "sha256-TIEUaINebINNhQdOaZg4h9cKFxnV3H6wpukX4/ZaBAc=";
    };
  };
  pyrime = {
    pname = "pyrime";
    version = "0.0.2";
    src = fetchurl {
      url = "https://pypi.org/packages/source/p/pyrime/pyrime-0.0.2.tar.gz";
      sha256 = "sha256-IdffUd66YaE0QLbz7zFDKi4TbzEmu5hfU0HtPA/EFB4=";
    };
  };
  requirements-language-server = {
    pname = "requirements-language-server";
    version = "0.0.21";
    src = fetchurl {
      url = "https://pypi.org/packages/source/r/requirements_language_server/requirements_language_server-0.0.21.tar.gz";
      sha256 = "sha256-y93uwqRqOq5MVpXq6wsR3Y4zT48UyWGS4gElQ8VajrA=";
    };
  };
  sublime-syntax-language-server = {
    pname = "sublime-syntax-language-server";
    version = "0.0.4";
    src = fetchurl {
      url = "https://pypi.org/packages/source/s/sublime-syntax-language-server/sublime-syntax-language-server-0.0.4.tar.gz";
      sha256 = "sha256-bC3gVsjJMccA5vxdwV6/DNTn81+RCAprjLgBMQAjyzs=";
    };
  };
  termux-language-server = {
    pname = "termux-language-server";
    version = "0.0.25";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/termux_language_server/termux_language_server-0.0.25.tar.gz";
      sha256 = "sha256-V2ITPsMNqn4F1CQHVoZ388CGcG+1ZKR8dfojAkPR0rU=";
    };
  };
  tmux-language-server = {
    pname = "tmux-language-server";
    version = "0.0.10";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tmux_language_server/tmux_language_server-0.0.10.tar.gz";
      sha256 = "sha256-SwQbyHJcPFyD9kLD9f7VQDJcMIOQXKEy3qdOt00L50g=";
    };
  };
  translate-shell = {
    pname = "translate-shell";
    version = "0.0.51";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/translate-shell/translate-shell-0.0.51.tar.gz";
      sha256 = "sha256-CrqcfyUH1EvagfoRUEMOdosK53nnQo56R6/hyX+ee7o=";
    };
  };
  tree-sitter-bash = {
    pname = "tree-sitter-bash";
    version = "v0.23.1";
    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter-bash";
      rev = "v0.23.1";
      fetchSubmodules = false;
      sha256 = "sha256-osQ2DMb5oOxQy1XqLYTYWXJK0Lq7rVfQP/LbulTEvq8=";
    };
  };
  tree-sitter-make = {
    pname = "tree-sitter-make";
    version = "1.0.1";
    src = fetchFromGitHub {
      owner = "Freed-Wu";
      repo = "tree-sitter-make";
      rev = "1.0.1";
      fetchSubmodules = false;
      sha256 = "sha256-AWHA+M6A++pLegCwmRLlHK5roIz7Y0iYkpfg5pJ+Bcs=";
    };
  };
  tree-sitter-muttrc = {
    pname = "tree-sitter-muttrc";
    version = "0.0.6";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_muttrc/tree_sitter_muttrc-0.0.6.tar.gz";
      sha256 = "sha256-BnxsTaOSSDImVs2BT3FmT/M6Gjzga4/MH24yFPt0pu0=";
    };
  };
  tree-sitter-requirements = {
    pname = "tree-sitter-requirements";
    version = "v0.4.0";
    src = fetchFromGitHub {
      owner = "tree-sitter-grammars";
      repo = "tree-sitter-requirements";
      rev = "v0.4.0";
      fetchSubmodules = false;
      sha256 = "sha256-wqaFpT/4Gq8mWoORcZeGah18VunvKlgr8gCgHQvEF6E=";
    };
  };
  tree-sitter-tmux = {
    pname = "tree-sitter-tmux";
    version = "0.0.4";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_tmux/tree_sitter_tmux-0.0.4.tar.gz";
      sha256 = "sha256-yGEMIItsfAV4bVLsa18GkS2lMxHmqxVbE3oimC8NfFE=";
    };
  };
  tree-sitter-zathurarc = {
    pname = "tree-sitter-zathurarc";
    version = "0.0.9";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_zathurarc/tree_sitter_zathurarc-0.0.9.tar.gz";
      sha256 = "sha256-a9UfhfiCqe6/kSVodetNhcgZKAtofRDRGvdQQ3aA/lI=";
    };
  };
  undollar = {
    pname = "undollar";
    version = "0.0.5";
    src = fetchFromGitHub {
      owner = "Freed-Wu";
      repo = "undollar";
      rev = "0.0.5";
      fetchSubmodules = false;
      sha256 = "sha256-HyWZz7wYnKDID8zs/a96YByjoPO7vKRAPZg6rL17sQ4=";
    };
  };
  windows10-icons = {
    pname = "windows10-icons";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "B00merang-Artwork";
      repo = "Windows-10";
      rev = "1.0";
      fetchSubmodules = false;
      sha256 = "sha256-Yz6a7FcgPfzz4w8cKp8oq7/usIBUUZV7qhVmDewmzrI=";
    };
  };
  windows10-themes = {
    pname = "windows10-themes";
    version = "3.2.1";
    src = fetchFromGitHub {
      owner = "B00merang-Project";
      repo = "Windows-10";
      rev = "3.2.1";
      fetchSubmodules = false;
      sha256 = "sha256-O8sKYHyr1gX1pQRTTSw/kHREJ5MujbVjmLHJHbrUcRM=";
    };
  };
  xilinx-language-server = {
    pname = "xilinx-language-server";
    version = "0.0.4";
    src = fetchurl {
      url = "https://pypi.org/packages/source/x/xilinx-language-server/xilinx-language-server-0.0.4.tar.gz";
      sha256 = "sha256-Qs2/RO4i0WHm4dmZh6iHmCLGkgTPLIBErc1n8YRvuk8=";
    };
  };
  zathura-language-server = {
    pname = "zathura-language-server";
    version = "0.0.13";
    src = fetchurl {
      url = "https://pypi.org/packages/source/z/zathura_language_server/zathura_language_server-0.0.13.tar.gz";
      sha256 = "sha256-jfqUMLHspSV2X+8dUGw0iyfl1dpAx9nllJqCxJ/r9Ss=";
    };
  };
}
