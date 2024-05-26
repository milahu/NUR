{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "mqtt-shell";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "rainu";
    repo = "mqtt-shell";
    rev = "v${version}";
    hash = "sha256-nyNNdlNC5AWJ9jTnBggUf4OVME3OPXWd1MAj2pWwQL4=";
  };

  vendorHash = "sha256-kC/APQjdKPjV7ap/2QONX1Y/glqbElNiXsa2uzRLIm8=";

  ldflags = [ "-X main.ApplicationVersion=${version}" ];

  doCheck = false;

  meta = {
    description = "A interactive shell-like command line interface (CLI) for MQTT";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sikmir ];
  };
}
