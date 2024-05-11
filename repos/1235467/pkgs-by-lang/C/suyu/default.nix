{ lib
, stdenv
, fetchFromGitLab
, nix-update-script
, wrapQtAppsHook
, autoconf
, boost
, catch2_3
, cmake
  #, compat-list
, cpp-jwt
, cubeb
, discord-rpc
, enet
, fmt
, glslang
, libopus
, libusb1
, libva
, lz4
, nlohmann_json
, nv-codec-headers-12
  #, nx_tzdb
, pkg-config
, qtbase
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, SDL2
, vulkan-headers
, vulkan-loader
, yasm
, zlib
, zstd
, pkgs
, ...
}:
let
  nx_tzdb = pkgs.callPackage ../../../_deps/yuzu/nx_tzdb.nix { };
  compat-list = pkgs.callPackage ../../../_deps/yuzu/compat-list.nix { };
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  pname = "suyu";
  inherit (sources.suyu) version src;

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers

    boost
    catch2_3
    cpp-jwt
    cubeb
    discord-rpc
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    # vendored ffmpeg deps
    autoconf
    yasm
    libva # for accelerated video decode on non-nvidia
    nv-codec-headers-12 # for accelerated video decode on nvidia
    # end vendored ffmpeg deps

    fmt
    # intentionally omitted: gamemode - loaded dynamically at runtime
    # intentionally omitted: httplib - upstream requires an older version than what we have
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    # not packaged in nixpkgs: simpleini
    # intentionally omitted: stb - header only libraries, vendor uses git snapshot
    # not packaged in nixpkgs: vulkan-memory-allocator
    # intentionally omitted: xbyak - prefer vendored version for compatibility
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DSUYU_ENABLE_LTO=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries
    "-DSUYU_USE_EXTERNAL_SDL2=OFF"
    "-DSUYU_USE_EXTERNAL_VULKAN_HEADERS=OFF"

    "-DSUYU_USE_BUNDLED_FFMPEG=OFF"

    # don't check for missing submodules
    "-DSUYU_CHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DSUYU_USE_QT_WEB_ENGINE=ON"
    "-DSUYU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DSUYU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${pname} | ${version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${pname} | ${version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  # This must be done after cmake finishes as it overwrites the file
  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  postInstall = ''
    install -Dm444 $src/dist/72-suyu-input.rules $out/lib/udev/rules.d/72-suyu-input.rules
  '';
}
