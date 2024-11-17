{ lib
, fetchFromGitHub
, rustPlatform
, callPackage
, ...
}:
let
  pname = "fww-checkin-rs";
  sources = callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.fww-checkin-rs) version src;

  cargoLock = {
    lockFile = "${sources.fww-checkin-rs.src}/Cargo.lock";
    #outputHashes = {
    #};
  };

  nativeBuildInputs = [
  ];

  buildInputs = [
  ];

  meta = with lib; {
    description = "A simple sosad.fun checkin script written in Rust";
    license = licenses.mit;
    maintainers = [ ];
  };
}
