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
    rev = "refs/tags/asio-1-22-1";
    sha256 = "sha256-UDLhx2yI6Txg0wP5H4oNIhgKIB2eMxUGCyT2x/7GgVg=";
  };

  # Derived from subprojects/bitsery.wrap
  bitsery = fetchFromGitHub {
    owner = "fraillt";
    repo = "bitsery";
    rev = "refs/tags/v5.2.2";
    sha256 = "sha256-VwzVtxt+E/SVcxqIJw8BKPO2q7bu/hkhY+nB7FHrZpY=";
  };

  # Derived from subprojects/clap.wrap
  clap = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = "refs/tags/1.1.7";
    sha256 = "sha256-WcMTxE+QCzlp4lhFdghZI8UI/5mdVeRvrl24Xynd0qk=";
  };

  # Derived from subprojects/function2.wrap
  function2 = fetchFromGitHub {
    owner = "Naios";
    repo = "function2";
    rev = "refs/tags/4.2.0";
    sha256 = "sha256-wrt+fCcM6YD4ZRZYvqqB+fNakCNmltdPZKlNkPLtgMs=";
  };

  # Derived from subprojects/ghc_filesystem.wrap
  ghc_filesystem = fetchFromGitHub {
    owner = "gulrak";
    repo = "filesystem";
    rev = "refs/tags/v1.5.12";
    sha256 = "sha256-j4RE5Ach7C7Kef4+H9AHSXa2L8OVyJljDwBduKcC4eE=";
  };

  # Derived from subprojects/tomlplusplus.wrap
  tomlplusplus = fetchFromGitHub {
    owner = "marzer";
    repo = "tomlplusplus";
    rev = "refs/tags/v3.3.0";
    sha256 = "sha256-INX8TOEumz4B5coSxhiV7opc3rYJuQXT2k1BJ3Aje1M=";
  };

  # Derived from vst3.wrap
  vst3 = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "vst3sdk";
    rev = "refs/tags/v3.7.7_build_19-patched";
    fetchSubmodules = true;
    sha256 = "sha256-LsPHPoAL21XOKmF1Wl/tvLJGzjaCLjaDAcUtDvXdXSU=";
  };
in
multiStdenv.mkDerivation (finalAttrs: {
  pname = "yabridge";
  version = "5.0.4";

  # NOTE: Also update yabridgectl's cargoHash when this is updated
  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "yabridge";
    rev = "refs/tags/${finalAttrs.version}";
    sha256 = "sha256-15WTCXMvghoU5TkE8yuQJrxj9cwVjczDKGKWjoUS6SI=";
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
    for exe in "$out"/bin/*.exe; do
      substituteInPlace "$exe" \
        --replace 'WINELOADER="wine"' 'WINELOADER="${wine}/bin/wine"'
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A modern and transparent way to use Windows VST2 and VST3 plugins on Linux";
    homepage = "https://github.com/robbert-vdh/yabridge";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" ];
  };
})
