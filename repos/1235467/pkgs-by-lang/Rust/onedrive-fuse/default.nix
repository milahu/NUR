{ lib
, fetchFromGitHub
, rustPlatform
, fuse3
, pkg-config
, openssl
, pkgs
, ...
}:
let
  pname = "onedrive-fuse";
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.onedrive-fuse) version src;
  cargoLock.lockFile = "${sources.onedrive-fuse.src}/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse3
    openssl
  ];

  meta = with lib; {
    description = "Mount your Microsoft OneDrive storage as FUSE filesystem";
    homepage = "https://github.com/oxalica/onedrive-fuse";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
