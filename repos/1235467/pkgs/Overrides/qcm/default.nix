{ stdenv
, pkgs
, lib
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
pkgs.qcm.overrideAttrs (
  prev: rec {
    inherit (sources.qcm) version src;
    meta = with lib; {
      description = "An unofficial Qt client for netease cloud music";
      homepage = "https://github.com/hypengw/Qcm";
      license = licenses.gpl2Plus;
      mainProgram = "Qcm";
      platforms = platforms.linux;
    };
  }
)
