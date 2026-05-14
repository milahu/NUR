{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fofax";
  version = "0.1.48";

  src = fetchFromGitHub {
    owner = "xiecat";
    repo = "fofax";
    rev = "v${version}";
    hash = "sha256-FhrMuTsEO6UqEl/OSgu+Yqz54e+0ZTsBXc+jnI//HN0=";
  };

  vendorHash = null;

  subPackages = [ "cmd/fofax" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "FOFA API query tool written in Go";
    homepage = "https://github.com/xiecat/fofax";
    license = licenses.mit;
    mainProgram = "fofax";
  };
}
