{ lib
, multiStdenv
, fetchFromGitHub
, substituteAll
, pkgsi686Linux
, dbus
, meson
, ninja
, pkg-config
, wine
, libxcb
, nix-update-script
}:

let
  # Derived from subprojects/asio.wrap
  asio = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "asio";
    rev = "refs/tags/asio-1-28-2";
    hash = "sha256-8Sw0LuAqZFw+dxlsTstlwz5oaz3+ZnKBuvSdLW6/DKQ=";
  };

  # Derived from subprojects/bitsery.wrap
  bitsery = fetchFromGitHub {
    owner = "fraillt";
    repo = "bitsery";
    rev = "refs/tags/v5.2.3";
    hash = "sha256-rmfcIYCrANycFuLtibQ5wOPwpMVhpTMpdGsUfpR3YsM=";
  };

  # Derived from subprojects/clap.wrap
  clap = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = "refs/tags/1.1.9";
    hash = "sha256-z2P0U2NkDK1/5oDV35jn/pTXCcspuM1y2RgZyYVVO3w=";
  };

  # Derived from subprojects/function2.wrap
  function2 = fetchFromGitHub {
    owner = "Naios";
    repo = "function2";
    rev = "refs/tags/4.2.3";
    hash = "sha256-+fzntJn1fRifOgJhh5yiv+sWR9pyaeeEi2c1+lqX3X8=";
  };

  # Derived from subprojects/ghc_filesystem.wrap
  ghc_filesystem = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "refs/tags/v1.5.14";
    hash = "sha256-XZ0IxyNIAs2tegktOGQevkLPbWHam/AOFT+M6wAWPFg=";
  };

  # Derived from subprojects/tomlplusplus.wrap
  tomlplusplus = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "refs/tags/v3.4.0";
    hash = "sha256-h5tbO0Rv2tZezY58yUbyRVpsfRjY3i+5TPkkxr6La8M=";
  };

  # Derived from vst3.wrap
  vst3 = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "vst3sdk";
    rev = "refs/tags/v3.7.7_build_19-patched";
    fetchSubmodules = true;
    hash = "sha256-LsPHPoAL21XOKmF1Wl/tvLJGzjaCLjaDAcUtDvXdXSU=";
  };
in
multiStdenv.mkDerivation (finalAttrs: {
  pname = "yabridge";
  version = "5.1.0";

  # NOTE: Also update yabridgectl's cargoHash when this is updated
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "yabridge";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-vnSdGedpiit8nym26i1QFiNnATk0Bymm7e5Ha2H41/M=";
  };

  # Unpack subproject sources
  postUnpack = ''(
    cd "$sourceRoot/subprojects"
    cp -R --no-preserve=mode,ownership ${asio} asio
    cp -R --no-preserve=mode,ownership ${bitsery} bitsery
    cp -R --no-preserve=mode,ownership ${clap} clap
    cp -R --no-preserve=mode,ownership ${function2} function2
    cp -R --no-preserve=mode,ownership ${ghc_filesystem} ghc_filesystem
    cp -R --no-preserve=mode,ownership ${tomlplusplus} tomlplusplus
    cp -R --no-preserve=mode,ownership ${vst3} vst3
  )'';

  patches = [
    # Hard code bitbridge & runtime dependencies
    (substituteAll {
      src = ./hardcode-dependencies.patch;
      libdbus = dbus.lib;
      libxcb32 = pkgsi686Linux.xorg.libxcb;
      inherit wine;
    })

    # Patch the chainloader to search for libyabridge through NIX_PROFILES
    ./libyabridge-from-nix-profiles.patch
  ];

  postPatch = ''
    patchShebangs .
    (
      cd subprojects
      cp packagefiles/asio/* asio
      cp packagefiles/bitsery/* bitsery
      cp packagefiles/clap/* clap
      cp packagefiles/function2/* function2
      cp packagefiles/ghc_filesystem/* ghc_filesystem
    )
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wine
  ];

  buildInputs = [
    libxcb
    dbus
  ];

  mesonFlags = [
    "--cross-file" "cross-wine.conf"
    "-Dbitbridge=true"

    # Requires CMake and is unnecessary
    "-Dtomlplusplus:generate_cmake_config=false"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/lib"
    cp yabridge-host{,-32}.exe{,.so} "$out/bin"
    cp libyabridge{,-chainloader}-{vst2,vst3,clap}.so "$out/lib"
    runHook postInstall
  '';

  # Hard code wine path in wrapper scripts generated by winegcc
  postFixup = ''
    substituteInPlace "$out/bin/yabridge-host-32.exe" \
      --replace 'WINELOADER="wine"' 'WINELOADER="${wine}/bin/wine"'

    substituteInPlace "$out/bin/yabridge-host.exe" \
      --replace 'WINELOADER="wine"' 'WINELOADER="${wine}/bin/wine64"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A modern and transparent way to use Windows VST2 and VST3 plugins on Linux";
    homepage = "https://github.com/robbert-vdh/yabridge";
    changelog = "https://github.com/robbert-vdh/yabridge/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" ];
  };
})
