{ lib, fetchFromGitHub, buildGoModule, pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
buildGoModule rec {
  pname = "swgp-go";
  inherit (sources.swgp-go) version src;

  vendorHash = "sha256-+3Ot06XXRJM1ebr/jgijA5bjsyWeN7M7uhx0MFuCZjY=";
  doCheck = false;
  meta = with lib; {
    description = "🐉 Simple WireGuard proxy with minimal overhead for WireGuard traffic";
    homepage = "https://github.com/database64128/swgp-go";
    #license = licenses.mit;
    #maintainers = with maintainers; [ bcdarwin ];
  };
}
