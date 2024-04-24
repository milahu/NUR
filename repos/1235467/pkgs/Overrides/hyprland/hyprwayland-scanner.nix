{ lib
, stdenv
, cmake
, pkg-config
, meson
, pkgs
, ...
} @ args:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
stdenv.mkDerivation rec {
  inherit (sources.hyprwayland-scanner) version src;
  pname = "hyprwayland-scanner";
  #doCheck = false;
  enableParallelBuilding = true;

  nativeBuildInputs = with pkgs; [
  pkg-config
  cmake
  meson
  pugixml
  ];
  BuildInputs = with pkgs; [
  ];
}
