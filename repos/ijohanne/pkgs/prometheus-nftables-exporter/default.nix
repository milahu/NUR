{ sources, pkgs, ... }:
pkgs.buildGoModule rec {
  name = "prometheus-nftables-exporter";
  src = sources.nftables_exporter;
  vendorHash = null;
  checkFlags = [ "-short" ];
  doCheck = false;
}
