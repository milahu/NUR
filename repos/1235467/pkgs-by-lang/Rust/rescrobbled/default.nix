{ lib
, fetchFromGitHub
, rustPlatform
, ffmpeg
, git
, nasm
, pkg-config
, openssl
, dbus
, pkgs
, ...
}:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
  pname = "rescrobbled";
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.rescrobbled) version src;
  cargoLock.lockFile = "${sources.rescrobbled.src}/Cargo.lock";

  nativeBuildInputs = [
    pkg-config
    dbus
  ];

  buildInputs = [
    ffmpeg
    git
    openssl
    dbus
    pkg-config
  ];
  checkFlags = [
    # reason for disabling test
    "--skip=filter::tests::test_filter_script"
  ];
  meta = with lib; {
    description = "MPRIS music scrobbler daemon";
    homepage = "https://github.com/InputUsername/rescrobbled";
    #license = licenses.gnu;
    maintainers = [ ];
  };
}
