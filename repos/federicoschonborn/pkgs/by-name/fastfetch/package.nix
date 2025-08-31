{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeBinaryWrapper,
  ninja,
  pkg-config,
  python3,
  yyjson,
  yyjson_0_12,
  apple-sdk_15,
  hwdata,
  versionCheckHook,
  nix-update-script,

  enableVulkan ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isDarwin
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isWindows
    || stdenv.hostPlatform.isAndroid
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  vulkan-loader,
  enableWayland ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isGnu,
  wayland,
  enableXcbRandr ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  enableXrandr ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  xorg,
  enableDrm ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  libdrm,
  enableDrmAmdgpu ?
    stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isGnu,
  enableGio ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  glib,
  libsysprof-capture,
  pcre2,
  libselinux,
  libsepol,
  util-linux,
  enableDconf ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  dconf,
  enableDbus ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  dbus,
  enableXfconf ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  xfce,
  enableSqlite3 ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isDarwin
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  sqlite,
  enableRpm ? stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isGnu,
  rpm,
  enableImagemagick ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isDarwin
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isWindows
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  imagemagick,
  enableChafa ? enableImagemagick,
  chafa,
  enableZlib ? enableImagemagick,
  zlib,
  enableEgl ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isAndroid
    || stdenv.hostPlatform.isWindows
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  libGL,
  enableGlx ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isAndroid
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  libglvnd,
  enableOpencl ?
    stdenv.hostPlatform.isLinux
    || stdenv.hostPlatform.isFreeBSD
    || stdenv.hostPlatform.isOpenBSD
    || stdenv.hostPlatform.isNetBSD
    || stdenv.hostPlatform.isWindows
    || stdenv.hostPlatform.isAndroid
    || stdenv.hostPlatform.isSunOS
    || stdenv.hostPlatform.isGnu,
  ocl-icd,
  opencl-headers,
  enableFreetype ? stdenv.hostPlatform.isAndroid,
  freetype,
  enablePulse ? stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isGnu,
  pulseaudio,
  enableDdcutil ? stdenv.hostPlatform.isLinux,
  ddcutil,
  enableDirectxHeaders ? stdenv.hostPlatform.isLinux,
  directx-headers,
  enableElf ?
    stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isAndroid || stdenv.hostPlatform.isGnu,
  libelf,
  enableLibzfs ?
    stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isSunOS,
  zfs,
  enablePciaccess ? stdenv.hostPlatform.isNetBSD || stdenv.hostPlatform.isOpenBSD,
  buildFlashfetch ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastfetch";
  version = "2.51.1";

  src = fetchFromGitHub {
    owner = "fastfetch-cli";
    repo = "fastfetch";
    tag = finalAttrs.version;
    hash = "sha256-RWQuW2XJpbQLFCzuHSJyYdv2RSAAOtlm/xbVd18Nv7A=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    (if lib.versionAtLeast yyjson.version "0.12" then yyjson else yyjson_0_12)
  ]
  ++ lib.optional enableVulkan vulkan-loader
  ++ lib.optional enableWayland wayland
  ++ lib.optionals enableXcbRandr [
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.libXext
  ]
  ++ lib.optional enableXrandr xorg.libXrandr
  ++ lib.optional (enableDrm || enableDrmAmdgpu) libdrm
  ++ (
    lib.optionals enableGio [
      glib
      libsysprof-capture
      pcre2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libselinux
      libsepol
      util-linux
    ]
  )
  ++ lib.optional enableDconf dconf
  ++ lib.optional enableDbus dbus
  ++ lib.optional enableXfconf xfce.xfconf
  ++ lib.optional enableSqlite3 sqlite
  ++ lib.optional enableRpm rpm
  ++ lib.optional enableImagemagick imagemagick
  ++ lib.optional enableChafa chafa
  ++ lib.optional enableZlib zlib
  ++ lib.optional enableEgl libGL
  ++ lib.optional enableGlx libglvnd
  ++ lib.optionals enableOpencl [
    ocl-icd
    opencl-headers
  ]
  ++ lib.optional enableFreetype freetype
  ++ lib.optional enablePulse pulseaudio
  ++ lib.optional enableDdcutil ddcutil
  ++ lib.optional enableDirectxHeaders directx-headers
  ++ lib.optional enableElf libelf
  ++ lib.optional enableLibzfs zfs
  ++ lib.optional enablePciaccess xorg.libpciaccess
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_15;

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeOptionType "filepath" "CMAKE_INSTALL_SYSCONFDIR" "${placeholder "out"}/etc")
    (lib.cmakeBool "ENABLE_SYSTEM_YYJSON" true)
    (lib.cmakeBool "ENABLE_VULKAN" enableVulkan)
    (lib.cmakeBool "ENABLE_WAYLAND" enableWayland)
    (lib.cmakeBool "ENABLE_XCB_RANDR" enableXcbRandr)
    (lib.cmakeBool "ENABLE_XRANDR" enableXrandr)
    (lib.cmakeBool "ENABLE_DRM" enableDrm)
    (lib.cmakeBool "ENABLE_DRM_AMDGPU" enableDrmAmdgpu)
    (lib.cmakeBool "ENABLE_GIO" enableGio)
    (lib.cmakeBool "ENABLE_DCONF" enableDconf)
    (lib.cmakeBool "ENABLE_DBUS" enableDbus)
    (lib.cmakeBool "ENABLE_XFCONF" enableXfconf)
    (lib.cmakeBool "ENABLE_SQLITE3" enableSqlite3)
    (lib.cmakeBool "ENABLE_RPM" enableRpm)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK7" enableImagemagick)
    (lib.cmakeBool "ENABLE_IMAGEMAGICK6" false)
    (lib.cmakeBool "ENABLE_CHAFA" enableChafa)
    (lib.cmakeBool "ENABLE_ZLIB" enableZlib)
    (lib.cmakeBool "ENABLE_EGL" enableEgl)
    (lib.cmakeBool "ENABLE_GLX" enableGlx)
    (lib.cmakeBool "ENABLE_OPENCL" enableOpencl)
    (lib.cmakeBool "ENABLE_FREETYPE" enableFreetype)
    (lib.cmakeBool "ENABLE_PULSE" enablePulse)
    (lib.cmakeBool "ENABLE_DDCUTIL" enableDdcutil)
    (lib.cmakeBool "ENABLE_DIRECTX_HEADERS" enableDirectxHeaders)
    (lib.cmakeBool "ENABLE_ELF" enableElf)
    (lib.cmakeBool "ENABLE_LIBZFS" enableLibzfs)
    (lib.cmakeBool "ENABLE_PCIACCESS" enablePciaccess)
    (lib.cmakeBool "BUILD_FLASHFETCH" buildFlashfetch)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeOptionType "filepath" "CUSTOM_PCI_IDS_PATH" "${hwdata}/share/hwdata/pci.ids")
    (lib.cmakeOptionType "filepath" "CUSTOM_AMDGPU_IDS_PATH" "${libdrm}/share/libdrm/amdgpu.ids")
  ];

  postPatch = ''
    substituteInPlace completions/fastfetch.fish --replace-fail python3 '${python3.interpreter}'
  '';

  postInstall = ''
    wrapProgram $out/bin/fastfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  ''
  + lib.optionalString buildFlashfetch ''
    wrapProgram $out/bin/flashfetch \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "fastfetch";
    description = "Like neofetch, but much faster because written in C";
    homepage = "https://github.com/fastfetch-cli/fastfetch";
    changelog = "https://github.com/fastfetch-cli/fastfetch/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
