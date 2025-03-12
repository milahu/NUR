# `result/bin/mslicer` fails with:
# called `Result::unwrap()` on an `Err` value: Wgpu(RequestDeviceError(RequestDeviceError { inner: Core(UnsupportedFeature(Features(POLYGON_MODE_LINE))) }))
{
  fetchFromGitHub,
  lib,
  libglvnd,
  libxkbcommon,
  pkg-config,
  rustPlatform,
  wayland,
  wayland-scanner,
  wayland-protocols,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "mslicer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = pname;
    rev = version;
    hash = "sha256-x46k1O7EqXMEwNATG4b7zHIYaMDVveRiq/Z5KPih0Fo=";
  };

  cargoHash = "sha256-mRbEwxR6bMkybxe7H1dX4Qa1elGiw/lSSz9sSTtp1zw=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    # cmake
    pkg-config
    wayland-scanner
    # wrapGAppsHook3  #< doesn't fix `POLYGON_MODE_LINE`
  ];

  buildInputs = [
    libglvnd
    libxkbcommon
    # openssl
    wayland
    wayland-protocols
  ];

  # from pkgs/by-name/al/alvr/package.nix, to get it to actually link against wayland
  # RUSTFLAGS = map (a: "-C link-arg=${a}") [
  #   "-Wl,--push-state,--no-as-needed"
  #   # "-lEGL"
  #   "-lwayland-client"
  #   # "-lxkbcommon"
  #   "-Wl,--pop-state"
  # ];

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client & libxkbcommon, which is dlopen()ed based on the
  # winit backend.
  # from <repo:nixos/nixpkgs:pkgs/by-name/uk/ukmm/package.nix>
  NIX_LDFLAGS = [
    "--push-state"
    "--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-lxkbcommon"
    "--pop-state"
  ];

  meta = with lib; {
    description = "An experimental open source slicer for masked stereolithography (resin) printers.";
    homepage = "https://connorcode.com/projects/mslicer";
    maintainers = with maintainers; [ colinsane ];
  };
}
