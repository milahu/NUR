{ lib, fetchFromGitHub, buildGoModule, pkgs }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
buildGoModule rec{
  pname = "open-snell";
  inherit (sources.open-snell) version src;

  vendorHash = "sha256-CcpUJefr1xouQYltcs4tojBS0aYcmk2x6I1fwcAaSMQ=";
  doCheck = false;
  meta = with lib; {
    description = "This is an unofficial open source port of https://github.com/surge-networks/snell";
    homepage = "https://github.com/icpz/open-snell";
    #license = licenses.mit;
    #maintainers = with maintainers; [ bcdarwin ];
  };
}
