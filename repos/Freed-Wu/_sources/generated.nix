# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  autotools-language-server = {
    pname = "autotools-language-server";
    version = "0.0.18";
    src = fetchurl {
      url = "https://pypi.org/packages/source/a/autotools-language-server/autotools-language-server-0.0.18.tar.gz";
      sha256 = "sha256-hTMHn9Y7cO5NQQVjMMnrzJh3jP55sJzdUrXtdXYWWyI=";
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
    version = "0.0.15";
    src = fetchurl {
      url = "https://pypi.org/packages/source/l/lsp-tree-sitter/lsp-tree-sitter-0.0.15.tar.gz";
      sha256 = "sha256-2zf+SYJ+IWdCQlYGum6Yv2z2U0RphsWIFV6Qj+zyeao=";
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
    version = "0.0.9";
    src = fetchurl {
      url = "https://pypi.org/packages/source/m/mutt-language-server/mutt-language-server-0.0.9.tar.gz";
      sha256 = "sha256-zuJBKcee/MdFvYECIIlxWL6FXDxa33VQtWEJXkfFRxM=";
    };
  };
  repl-python-wakatime = {
    pname = "repl-python-wakatime";
    version = "0.0.11";
    src = fetchurl {
      url = "https://pypi.org/packages/source/r/repl-python-wakatime/repl-python-wakatime-0.0.11.tar.gz";
      sha256 = "sha256-HoCdeo03Lf3g5Xg0GgAyWOu2PtGqy33vg5bQrfkEPkE=";
    };
  };
  requirements-language-server = {
    pname = "requirements-language-server";
    version = "0.0.20";
    src = fetchurl {
      url = "https://pypi.org/packages/source/r/requirements-language-server/requirements-language-server-0.0.20.tar.gz";
      sha256 = "sha256-U2KDz+S+yQW5XBlVK9ym3bZE123w7N/1lxWeQj8oRPw=";
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
    version = "0.0.22";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/termux-language-server/termux-language-server-0.0.22.tar.gz";
      sha256 = "sha256-SfJPyIijMhiQjwaQrBaqCYOtPIK+u9XozRzM3+h2dV4=";
    };
  };
  tmux-language-server = {
    pname = "tmux-language-server";
    version = "0.0.8";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tmux-language-server/tmux-language-server-0.0.8.tar.gz";
      sha256 = "sha256-KsOfy/gaZr11qRtHR9Zv2nz+cwKem7+9Qmt7tcfoXGQ=";
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
  tree-sitter-languages = {
    pname = "tree-sitter-languages";
    version = "v1.10.2";
    src = fetchFromGitHub {
      owner = "grantjenks";
      repo = "py-tree-sitter-languages";
      rev = "v1.10.2";
      fetchSubmodules = false;
      sha256 = "sha256-AuPK15xtLiQx6N2OATVJFecsL8k3pOagrWu1GascbwM=";
    };
  };
  tree-sitter-muttrc = {
    pname = "tree-sitter-muttrc";
    version = "0.0.3";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_muttrc/tree_sitter_muttrc-0.0.3.tar.gz";
      sha256 = "sha256-xXB0V/RPTmE5ickY1T3N5PfxfI+vkSgLw1JhViRTDdg=";
    };
  };
  tree-sitter-requirements = {
    pname = "tree-sitter-requirements";
    version = "v0.3.3";
    src = fetchFromGitHub {
      owner = "tree-sitter-grammars";
      repo = "tree-sitter-requirements";
      rev = "v0.3.3";
      fetchSubmodules = false;
      sha256 = "sha256-M+/I0pn79Juk8LRB6LLRAyA3R5zcm6rIoR4viT9SW0c=";
    };
  };
  tree-sitter-tmux = {
    pname = "tree-sitter-tmux";
    version = "0.0.2";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_tmux/tree_sitter_tmux-0.0.2.tar.gz";
      sha256 = "sha256-72Eegy5lYm0OsFaV7IdwH0IPrnm7UX5k6i9aMRlxlDc=";
    };
  };
  tree-sitter-zathurarc = {
    pname = "tree-sitter-zathurarc";
    version = "0.0.6";
    src = fetchurl {
      url = "https://pypi.org/packages/source/t/tree_sitter_zathurarc/tree_sitter_zathurarc-0.0.6.tar.gz";
      sha256 = "sha256-qCNreYPQzKU2aL9o8fZhLAzjyLIb8vboJfMtc84YSe0=";
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
    version = "0.0.11";
    src = fetchurl {
      url = "https://pypi.org/packages/source/z/zathura-language-server/zathura-language-server-0.0.11.tar.gz";
      sha256 = "sha256-AVCmqBH/iQNc3LyOiuGnUsaEaNQfeERw17q0Cm4CaY8=";
    };
  };
}
