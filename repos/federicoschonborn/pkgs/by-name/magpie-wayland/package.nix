{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  argparse,
  libxkbcommon,
  pixman,
  systemd,
  wayland-protocols,
  wlroots_0_17,
  xorg,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "magpie-wayland";
  version = "0.9.3-unstable-2024-07-05";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "magpie";
    rev = "3eb92dee4d3e963531271e6e42f56f66301421b7";
    hash = "sha256-M+jCLYgT//1JaprLh2BIn4kFmuq1lBn/nI0xDrACg1w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland # wayland-scanner
  ];

  buildInputs = [
    argparse
    libxkbcommon
    pixman
    systemd
    wayland-protocols
    wlroots_0_17
    xorg.libxcb
    xorg.xcbutilwm
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=v1"
    ];
  };

  meta = {
    mainProgram = "magpie-wm";
    description = "wlroots-based Wayland compositor designed for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/magpie";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.federicoschonborn ];
  };
}
