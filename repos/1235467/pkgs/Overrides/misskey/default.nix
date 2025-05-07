{ stdenv
, pkgs
, lib
, ...
}:
pkgs.misskey.overrideAttrs (
  prev: rec {
    version = "2025.4.1";
    src = (prev.src or { }) // { hash = ""; };
    patches = [];
    pnpmDeps = prev.pnpmDeps or { hash = ""; };
  }
)
