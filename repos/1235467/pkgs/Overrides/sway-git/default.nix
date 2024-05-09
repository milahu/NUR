  { stdenv
, pkgs
, lib
, fetchurl
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  wayland-git = pkgs.wayland.overrideAttrs (previousAttrs: rec {
      inherit (sources.wayland) version src;
  });
  libdrm-git = pkgs.wayland.overrideAttrs (previousAttrs: rec {
      inherit (sources.libdrm) version src;
  });
  wayland-protocols-git = pkgs.wayland.overrideAttrs (previousAttrs: rec {
      inherit (sources.wayland-protocols) version src;
  });
  wlroots-git = pkgs.wayland.overrideAttrs (previousAttrs: rec {
      inherit (sources.wlroots) version src;
  });
  wayland-scanner-git = wayland-git.bin;
in
pkgs.sway.override (previous: {
    sway-unwrapped = previous.sway-unwrapped.overrideAttrs (previousAttrs: rec {
      inherit (sources.sway) version src;
      patches = previousAttrs.patches ++
      [
        #"${sources.sway-im.src}/0001-text_input-Implement-input-method-popups.patch"
        #"${sources.sway-im.src}/0002-chore-fractal-scale-handle.patch"
        #"${sources.sway-im.src}/0003-chore-left_pt-on-method-popup.patch"
      ];
      buildInputs = previousAttrs.buildInputs ++
      [
      wayland-git
      wayland-protocols-git
      libdrm-git
      (wlroots-git.override { enableXWayland = true;})
      ];
      nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
      wayland-scanner-git
      ];
  });
})
