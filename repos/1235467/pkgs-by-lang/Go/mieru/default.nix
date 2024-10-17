{ lib, fetchFromGitHub, buildGoModule, pkgs }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
buildGoModule rec{
  pname = "mieru";
  inherit (sources.mieru) version src;

  vendorHash = "sha256-8wIPivchmhEZYhX9LfbmriMMRnxvtXhLjz7u+ukJPxo=";
  doCheck = false;
  meta = with lib; {
    description = "mieru";
    homepage = "https://github.com/enfein/mieru";
    #license = licenses.mit;
    #maintainers = with maintainers; [ bcdarwin ];
  };
}
