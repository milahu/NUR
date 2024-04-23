# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { }
, pkgs-stable ? import <nixpkgs> { }
}:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays


  # Eval Helper
  sources = pkgs.callPackage ./_sources/generated.nix { };

  # Build Helper
  buildtools = pkgs.callPackage ./buildtools/shell {};

  # Rust
  ab-av1 = pkgs.callPackage ./pkgs-by-lang/Rust/ab-av1 { };
  Anime4k-rs = pkgs.callPackage ./pkgs-by-lang/Rust/Anime4k-rs { };
  av1an = pkgs.callPackage ./pkgs-by-lang/Rust/av1an { };
  #DownOnSpot = pkgs.callPackage ./pkgs-by-lang/Rust/DownOnSpot { };
  ncmdump-rs = pkgs.callPackage ./pkgs-by-lang/Rust/ncmdump.rs { };
  onedrive-fuse = pkgs.callPackage ./pkgs-by-lang/Rust/onedrive-fuse { };
  rescrobbled = pkgs.callPackage ./pkgs-by-lang/Rust/rescrobbled { };
  sakaya = pkgs.callPackage ./pkgs-by-lang/Rust/sakaya { };
  waylyrics = pkgs.callPackage ./pkgs-by-lang/Rust/waylyrics { };

  # Dotnet
  BBDown = pkgs.callPackage ./pkgs-by-lang/Dotnet/BBDown { };

  # Go
  open-snell = pkgs.callPackage ./pkgs-by-lang/Go/open-snell { };
  #swgp-go = pkgs.callPackage ./pkgs-by-lang/Go/swgp-go { };

  # Python
  idntag = pkgs.callPackage ./pkgs-by-lang/Python/idntag { };
  jjwxcCrawler = pkgs.callPackage ./pkgs-by-lang/Python/jjwxcCrawler { };
  pynat = pkgs.callPackage ./pkgs-by-lang/Python/pynat { };
  pystun3 = pkgs.callPackage ./pkgs-by-lang/Python/pystun3 { };
  together-cli = pkgs.callPackage ./pkgs-by-lang/Python/together_cli { };

  # C
  candy = pkgs.callPackage ./pkgs-by-lang/C/candy {};
  HDiffPatch = pkgs.callPackage ./pkgs-by-lang/C/HDiffPatch { };
  kagi-cli-shortcut = pkgs.callPackage ./pkgs-by-lang/C/kagi-cli-shortcut { };
  koboldcpp = pkgs.callPackage ./pkgs-by-lang/C/koboldcpp {};
  Penguin-Subtitle-Player = pkgs.libsForQt5.callPackage ./pkgs-by-lang/C/Penguin-Subtitle-Player { };
  suyu = pkgs.qt6.callPackage ./pkgs-by-lang/C/suyu {};
  #vkbasalt = pkgs.callPackage ./pkgs-by-lang/C/vkbasalt {};
  #yumekey = pkgs.callPackage ./pkgs-by-lang/C/yumekey {};
  yuzu-early-access = pkgs.qt6.callPackage ./pkgs-by-lang/C/yuzu { };
  nbfc-linux = pkgs.callPackage ./pkgs-by-lang/C/nbfc-linux {};
  #sudachi = pkgs.qt6.callPackage ./pkgs-by-lang/C/sudachi {};

  # Shell
  reflac = pkgs.callPackage ./pkgs-by-lang/Shell/reflac { };

  # AppImage
  cider = pkgs.callPackage ./pkgs/AppImage/cider { };
  hydrogen-music = pkgs.callPackage ./pkgs/AppImage/hydrogen-music { };

  # Bin
  basilisk = pkgs.callPackage ./pkgs/Bin/basilisk {withGTK3=true;};
  feishu = pkgs.callPackage ./pkgs/Bin/feishu { };
  wechat = pkgs.callPackage ./pkgs/Bin/wechat {};
  #wemeet = pkgs.callPackage ./pkgs/Bin/wemeet { };

  # Overrides
  forkgram = pkgs.qt6.callPackage ./pkgs/Overrides/forkgram {};
  #openmw = pkgs.libsForQt5.callPackage ./pkgs/Overrides/openmw {};
  qcm = pkgs.qt6.callPackage ./pkgs/Overrides/qcm {};
  mpv = pkgs.wrapMpv (pkgs.mpv.unwrapped.override { cddaSupport = true; }) {scripts = [ pkgs.mpvScripts.mpris ];};
  sway-im = pkgs.callPackage ./pkgs/Overrides/sway-im {};
  hyprland = pkgs.callPackage ./pkgs/Overrides/hyprland {};
  pot = pkgs.callPackage ./pkgs/Overrides/pot {};

  # System Fonts override
  JetBrainsMono-nerdfonts = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ];};

  # Garnix generate cache
  mongodb = pkgs-stable.mongodb;
  cudatoolkit = pkgs.cudaPackages_12.cudatoolkit;
}
