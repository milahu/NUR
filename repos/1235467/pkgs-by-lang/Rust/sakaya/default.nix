{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkgs
, ...
}:
let
  pname = "sakaya";
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
rustPlatform.buildRustPackage {
  inherit pname;
  inherit (sources.sakaya) version src;
  cargoLock.lockFile = "${sources.sakaya.src}/Cargo.lock";


  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage target/man/sakaya.1

    installShellCompletion --cmd sakaya \
      --bash <(cat target/completions/sakaya.bash) \
      --fish <(cat target/completions/sakaya.fish) \
      --zsh <(cat target/completions/_sakaya)
  '';
}
