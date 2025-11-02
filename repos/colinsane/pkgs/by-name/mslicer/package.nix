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
  version = "0.2.2-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "connorslade";
    repo = "mslicer";
    rev = "7ce2660693b09f464016397b163fcb8d05f2edca";
    hash = "sha256-FYapz7DFVyjMsIiz5Q1nxtYcFrNpIBuvknxMpOV22C4=";
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
