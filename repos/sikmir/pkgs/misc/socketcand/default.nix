{ lib, stdenv, fetchFromGitHub, autoreconfHook, installShellFiles, libconfig }:

stdenv.mkDerivation rec {
  pname = "socketcand";
  version = "0.6.1-unstable-2023-12-06";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "socketcand";
    rev = "02ad0f5a9c9387b8ccfdef837068584b721eff05";
    hash = "sha256-Fsx5eIbiIYctfRcEU5iyG2hKcSV/7R7EyR6WlVFDTCk=";
  };

  nativeBuildInputs = [ autoreconfHook installShellFiles ];

  buildInputs = [ libconfig ];

  installPhase = ''
    runHook preInstall
    install -Dm755 socketcand socketcandcl -t $out/bin
    installManPage socketcand.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Server to access CAN sockets over ASCII protocol";
    inherit (src.meta) homepage;
    license = with licenses; [ gpl2Only bsd3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.sikmir ];
    skip.ci = stdenv.isDarwin;
  };
}
