{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.job;
in {
  options.services.job = {
    client = mkEnableOption ''
      Programs for job
    '';
    server = mkEnableOption ''
      Services for job
    '';
  };

  config = mkMerge [
    (mkIf cfg.client {
      environment.systemPackages = with pkgs; with pkgs.nur.repos.dukzcry; [ remmina yandex-disk ];
      programs.evolution.plugins = [ pkgs.evolution-ews ];
      services.xserver.displayManager.sessionCommands = ''
        yandex-disk start
      '';
    })
    (mkIf cfg.server {
      networking.nftables.tables = {
        job = {
          family = "ip";
          content = ''
            chain post {
              type nat hook postrouting priority srcnat;
              oifname "job" counter masquerade
            }
          '';
        };
      };
    })
  ];
}
