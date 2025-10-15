{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    nixpkgs-yuzu = {
      url = "github:NixOS/nixpkgs/71e91c409d1e654808b2621f28a327acfdad8dc2";
    };
  };
  inputs.dream2nix.url = "github:nix-community/dream2nix";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  #inputs.chaotic.url = "github:chaotic-cx/nyx/dc2d9e585f0dac249f4458d107da14bc132482cb";
  inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";  

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , nixpkgs-yuzu
    , dream2nix
    , chaotic
    , ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      system = "x86_64-linux";
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    rec {
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-yuzu = import nixpkgs-yuzu {
            inherit system;
            config.allowUnfree = true;
          };
        }
      );
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          pkgs-stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
          pkgs-yuzu = import nixpkgs-yuzu { inherit system; config.allowUnfree = true; };
          pkgs-chaotic = inputs.chaotic.legacyPackages.${system};
        in
        rec
        {
          # Build Helper
          buildtools = pkgs-stable.callPackage ./buildtools/shell { };

          # Rust
          ncmdump-rs = pkgs.callPackage ./pkgs-by-lang/Rust/ncmdump.rs { };
          rescrobbled = pkgs.callPackage ./pkgs-by-lang/Rust/rescrobbled { };
          #waylyrics = pkgs.callPackage ./pkgs-by-lang/Rust/waylyrics { };
          aichat = pkgs.callPackage ./pkgs-by-lang/Rust/aichat { };
          fww-checkin-rs = pkgs.callPackage ./pkgs-by-lang/Rust/fww-checkin-rs { };

          # Dotnet
          BBDown = pkgs.callPackage ./pkgs-by-lang/Dotnet/BBDown { };

          # Go
          #open-snell = pkgs.callPackage ./pkgs-by-lang/Go/open-snell { };
          #mieru = pkgs.callPackage ./pkgs-by-lang/Go/mieru { };
          T2D = pkgs.callPackage ./pkgs-by-lang/Go/T2D { };

          # Python
          jjwxcCrawler = pkgs.callPackage ./pkgs-by-lang/Python/jjwxcCrawler { };
          pynat = pkgs.callPackage ./pkgs-by-lang/Python/pynat { };
          pystun3 = pkgs.callPackage ./pkgs-by-lang/Python/pystun3 { };
          #LinguaGacha = pkgs.callPackage ./pkgs-by-lang/Python/LinguaGacha { };

          # C
          candy = pkgs.callPackage ./pkgs-by-lang/C/candy { };
          HDiffPatch = pkgs.callPackage ./pkgs-by-lang/C/HDiffPatch { };
          kagi-cli-shortcut = pkgs.callPackage ./pkgs-by-lang/C/kagi-cli-shortcut { };
          #koboldcpp = pkgs.callPackage ./pkgs-by-lang/C/koboldcpp { };
          Penguin-Subtitle-Player = pkgs.libsForQt5.callPackage ./pkgs-by-lang/C/Penguin-Subtitle-Player { };
          suyu = pkgs-yuzu.qt6.callPackage ./pkgs-by-lang/C/suyu { };
          yuzu-early-access = pkgs-yuzu.qt6.callPackage ./pkgs-by-lang/C/yuzu { };
          rtptun = pkgs.callPackage ./pkgs-by-lang/C/rtptun { };

          # Nodejs

          # Shell
          reflac = pkgs.callPackage ./pkgs-by-lang/Shell/reflac { };

          # AppImage
          cider = pkgs.callPackage ./pkgs/AppImage/cider { };
          hydrogen-music = pkgs.callPackage ./pkgs/AppImage/hydrogen-music { };

          # Bin
          feishu = pkgs.callPackage ./pkgs/Bin/feishu { };
          wechat = pkgs.callPackage ./pkgs/Bin/wechat { };
          cider3 = pkgs.callPackage ./pkgs/Bin/cider3 { };

          # Overrides
          mpv = pkgs.mpv-unwrapped.wrapper {
            mpv = (pkgs.mpv-unwrapped.override { cddaSupport = true; });
            scripts = [ pkgs.mpvScripts.mpris ];
          };
          misskey-new = pkgs.callPackage ./pkgs/Overrides/misskey { };
          llama-cpp-cuda = (pkgs.llama-cpp.override { config = { cudaSupport = true; rocmSupport = false; }; });
          linux_cachyos-lto-x86_64-v3 = (pkgs-chaotic.linuxPackages_cachyos-lto.cachyOverride { mArch = "GENERIC_V3"; }).kernel; # for cache
          inputplumber = pkgs.callPackage ./pkgs-by-lang/Rust/inputplumber { };
          xivlauncher-cn = pkgs.callPackage ./pkgs/Overrides/xivlauncher { };

          # System Fonts override
          JetBrainsMono-nerdfonts = pkgs.nerd-fonts.jetbrains-mono;

          # Garnix generate cache
          mongodb = pkgs-stable.mongodb;
          cudatoolkit = pkgs.cudaPackages_12.cudatoolkit;
          misskey = pkgs.misskey;
          koboldcpp = (pkgs.koboldcpp.override { cublasSupport = true; clblastSupport = true; vulkanSupport = true; cudaArches = [ "sm_75" ]; });
          # Fonts
          ttf-ms-win10 = pkgs.callPackage ./pkgs/Fonts/ttf-ms-win10 { };
        }
      );
    };

}
