{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  glslang,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  vulkan-headers,
  boost,
  fmt,
  lz4,
  nlohmann_json,
  qtbase,
  qtmultimedia,
  qtwayland,
  qtwebengine,
  SDL2,
  zlib,
  zstd,
  rapidjson,
  libva,
  libvdpau,
  nv-codec-headers-12,
  yasm,
  autoconf,
  automake,
  libtool,
  spirv-headers,
  catch2_3,
  vulkan-loader,
  nix-update-script,
}:

let
  # Derived from externals/nx_tzdb/CMakeLists.txt
  nx_tzdb = fetchzip {
    url = "https://github.com/lat9nq/tzdb_to_nx/releases/download/221202/221202.zip";
    stripRoot = false;
    hash = "sha256-YOIElcKTiclem05trZsA3YJReozu/ex7jJAKD6nAMwc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sudachi";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "sudachi-emu";
    repo = "sudachi";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-KPGBfY80isNlJdFdopP5qqni3Ll7TIC3MC2MGDf8xZ4=";
  };

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
    fmt
    lz4
    nlohmann_json
    qtbase
    qtmultimedia
    qtwayland
    qtwebengine
    SDL2
    zlib
    zstd

    # vendored discord-rpc deps
    rapidjson

    # vendored ffmpeg deps
    libva # for accelerated video decode on non-nvidia
    libvdpau # for accelerated video decode on non-nvidia
    nv-codec-headers-12 # for accelerated video decode on nvidia
    yasm

    # vendored libusb deps
    autoconf
    automake
    libtool

    # vendored sirit deps
    spirv-headers
  ];

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DSUDACHI_ENABLE_LTO=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    # "-DENABLE_QT_TRANSLATION=ON" (broken)

    # enable some optional features
    "-DSUDACHI_USE_QT_WEB_ENGINE=ON"
    "-DSUDACHI_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # compatibility list currently 404's
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF"

    # don't check for missing submodules
    "-DSUDACHI_CHECK_SUBMODULES=OFF"

    # use system libraries
    # NB: "external" here means "from the externals/ directory in the source",
    # so "off" means "use system"
    "-DSUDACHI_USE_EXTERNAL_SDL2=OFF"
    "-DSUDACHI_USE_EXTERNAL_VULKAN_HEADERS=OFF"

    # don't use system ffmpeg, sudachi uses internal APIs
    "-DSUDACHI_USE_BUNDLED_FFMPEG=ON"
    "-DFFmpeg_COMPONENTS='swscale;avutil;avfilter;avcodec'"
    "-DFFmpeg_PREFIX=$src/externals/ffmpeg/ffmpeg"

    # use system spriv headers for sirit
    "-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=ON"
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
    )

    # provide pre-downloaded tz data
    mkdir -p build/externals/nx_tzdb
    ln -s ${nx_tzdb} build/externals/nx_tzdb/nx_tzdb
  '';

  doCheck = true;
  checkInputs = [ catch2_3 ];

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib" ];

  postInstall = ''
    install -Dm444 $src/dist/72-sudachi-input.rules $out/lib/udev/rules.d/72-sudachi-input.rules
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://sudachi-emu.com";
    changelog = "https://github.com/sudachi-emu/sudachi/releases/tag/v${version}";
    description = "Nintendo Switch emulator written in C++";
    mainProgram = "sudachi";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    license = with licenses; [
      gpl3Plus

      # Icons
      asl20
      mit
      cc0
    ];

    maintainers = with maintainers; [ kira-bruneau ];
  };
})
