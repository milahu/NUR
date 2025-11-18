{
  fetchFromGitHub,
  lib,
  libglvnd,
  libxkbcommon,
  nix-update-script,
  rustPlatform,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "mslicer";
  version = "0.3.0-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = "741bfe30d05e22cbf2d6310ffbb9e67205413048";
    hash = "sha256-k/LoJ+GqtVHZab5BEXQ5k2SJkM9hwbOkPA6c+3i9Ylo=";
  };

  cargoHash = "sha256-a+nIVDjR+7Bh36GPNtWqKQvQgNo0w3KHWPmYpU7WMkM=";

  buildInputs = [
    libglvnd
    libxkbcommon
    vulkan-loader
    wayland
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
    "-lvulkan"
    "-lwayland-client"
    "-lxkbcommon"
    "--pop-state"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # spot-check the binaries
    $out/bin/goo_format --help
    # these other binaries can't be invoked w/ interactivity or real data:
    test -x $out/bin/mslicer
    test -x $out/bin/remote_send
    test -x $out/bin/slicer

    runHook postInstallCheck
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "An experimental open source slicer for masked stereolithography (resin) printers.";
    homepage = "https://connorcode.com/projects/mslicer";
    maintainers = with maintainers; [ colinsane ];
  };
}
