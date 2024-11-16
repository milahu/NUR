{ lib
, fetchFromGitHub
, rustPlatform
, callPackage
, ...
}:
let
  pname = "aichat";
  sources = callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.aichat) version src;

  cargoLock = {
    lockFile = "${sources.aichat.src}/Cargo.lock";
    #outputHashes = {
    #};
  };

  nativeBuildInputs = [
  ];

  buildInputs = [
  ];

  meta = with lib; {
    description = "A simple chatbot written in Rust";
    license = licenses.mit;
    maintainers = [ ];
  };
}
