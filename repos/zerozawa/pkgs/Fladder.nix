{
  lib,
  config,
  fetchFromGitHub,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? {},
  stdenv,
  autoAddDriverRunpath,
  autoPatchelfHook,
  flutter,
  yq-go,
  pkg-config,
  mpv,
  alsa-lib,
  gtk3,
  glib,
  libepoxy,
  sqlite,
  libunwind,
  libdovi,
  makeDesktopItem,
  copyDesktopItems,
  runCommand,
  ...
}: let
  stdenv' =
    if cudaSupport
    then cudaPackages.backendStdenv
    else stdenv;
  pname = "Fladder";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "DonutWare";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Rpnf4fYsChbCsezBtmqQ8xkaj6HmfnDPvZLSZjPEPJ0=";
  };
  media_kit_rev = "46bf02c1a49be19bee4e9c2c41bc2209b4884c33";
  media_kit_hash = "sha256-Vw/XMFa4TBHS69fJcnCOKfEuTCuZ+Yqdz/WPMLIXQEk=";
  importYaml = file: let
    converted = runCommand "converted-yaml.json" {nativeBuildInputs = [yq-go];} ''
      yq -e -o=json . ${file} > $out
    '';
  in
    builtins.fromJSON (builtins.readFile converted);
in
  (flutter.override {
    stdenv = stdenv';
  }).buildFlutterApplication rec {
    inherit pname version src;
    pubspecLock = importYaml "${src}/pubspec.lock";
    gitHashes = {
      media_kit = media_kit_hash;
      media_kit_libs_android_video = media_kit_hash;
      media_kit_libs_ios_video = media_kit_hash;
      media_kit_libs_linux = media_kit_hash;
      media_kit_libs_macos_video = media_kit_hash;
      media_kit_libs_video = media_kit_hash;
      media_kit_libs_windows_video = media_kit_hash;
      media_kit_video = media_kit_hash;
    };

    # 覆盖内置的 media_kit_libs_linux 包源构建器，使用 DonutWare 的 fork
    customSourceBuilders = {
      media_kit_libs_linux = {
        version,
        src,
        ...
      }:
      # 使用 NixOS 内置的构建器逻辑，但替换为 DonutWare 的源
      let
        # DonutWare fork 的源码（与 gitHashes 中的 commit 一致）
        donutware-src = fetchFromGitHub {
          owner = "DonutWare";
          repo = "media-kit";
          rev = media_kit_rev;
          hash = media_kit_hash;
        };
      in
        stdenv.mkDerivation {
          pname = "media_kit_libs_linux";
          inherit version;
          # 使用 DonutWare fork 的源码，并设置正确的子路径
          src = "${donutware-src}/libs/linux/media_kit_libs_linux";

          # 保持与原包源构建器相同的 passthru 属性
          passthru.packageRoot = ".";

          dontBuild = true;

          # 应用 NixOS 内置的补丁逻辑
          postPatch =
            lib.optionalString (lib.versionAtLeast version "1.2.1") ''
              sed -i '/if(MIMALLOC_USE_STATIC_LIBS)/,/unset(MIMALLOC_USE_STATIC_LIBS CACHE)/d' linux/CMakeLists.txt
            ''
            + lib.optionalString (lib.versionOlder version "1.2.1") ''
              awk -i inplace 'BEGIN {opened = 0}; /# --*[^$]*/ { print (opened ? "]===]" : "#[===["); opened = !opened }; {print $0}' linux/CMakeLists.txt
            '';

          installPhase = ''
            runHook preInstall
            cp -r . $out
            runHook postInstall
          '';
        };

      # 为 fvp 插件添加自定义构建器，预下载 mdk-sdk
      fvp = {
        version,
        src,
        ...
      }: let
        # 预下载 mdk-sdk Linux 版本
        mdk-sdk-linux = stdenv.mkDerivation rec {
          pname = "mdk-sdk-linux";
          version = "0.35.0";

          src = builtins.fetchurl {
            url = "https://github.com/wang-bin/mdk-sdk/releases/download/v${version}/${pname}-x64.tar.xz";
            sha256 = "044yw4iln4qq6zshmp3f5k08dq8rl6vsnh3xn5ldh04lh4sxm88r";
          };

          unpackPhase = ''
            tar -xf $src
          '';

          installPhase = ''
            mkdir -p $out
            cp -r . $out/
          '';
        };
      in
        stdenv.mkDerivation {
          pname = "fvp";
          inherit version src;
          inherit (src) passthru;

          dontBuild = true;

          postPatch = ''
            # 禁用网络下载，使用预下载的 mdk-sdk
            if [ -f linux/CMakeLists.txt ]; then
              substituteInPlace linux/CMakeLists.txt \
                --replace 'fvp_setup_deps(''${CMAKE_CURRENT_LIST_DIR})' '# fvp_setup_deps disabled - using predownloaded mdk-sdk'

              # 创建 mdk-sdk 目录并复制文件
              mkdir -p linux/mdk-sdk-linux-x64
              cp -r ${mdk-sdk-linux}/* linux/
            fi
          '';

          installPhase = ''
            runHook preInstall
            cp -r . $out
            runHook postInstall
          '';
        };
    };

    # 添加必要的系统依赖
    nativeBuildInputs =
      [pkg-config autoPatchelfHook copyDesktopItems]
      ++ lib.optionals cudaSupport [
        autoAddDriverRunpath
        cudaPackages.cuda_nvcc
        (lib.getDev cudaPackages.cuda_cudart)
      ];
    buildInputs =
      [
        mpv
        gtk3
        alsa-lib
        glib
        libepoxy
        sqlite
        libunwind
        libdovi
      ]
      ++ mpv.unwrapped.buildInputs
      ++ lib.optionals cudaSupport [
        cudaPackages.cudatoolkit
        cudaPackages.cuda_cudart
      ];
    desktopItems = [
      (makeDesktopItem {
        name = pname;
        startupWMClass = "nl.jknaapen.fladder";
        comment = "A Simple Jellyfin Frontend built on top of Flutter.";
        exec = pname;
        icon = "fladder_icon_desktop";
        desktopName = pname;
        categories = [
          "Video"
          "TV"
        ];
        type = "Application";
        terminal = false;
      })
    ];

    postInstall = ''
      mkdir -p $out/bin $out/share/pixmaps
      cp ${src}/icons/production/fladder_icon_desktop.png $out/share/pixmaps/fladder_icon_desktop.png
    '';

    preferLocalBuild = true;

    meta = with lib; {
      description = "A Simple Jellyfin Frontend built on top of Flutter.";
      homepage = "https://github.com/DonutWare/Fladder";
      platforms = with platforms; (intersectLists x86 linux);
      license = with licenses; [gpl3Only];
      mainProgram = pname;
      sourceProvenance = with sourceTypes; [fromSource];
    };
  }
