{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.prometheus-nftables-exporter;
  name = "nftables";
in
{
  options.services.prometheus-nftables-exporter = with types; mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "the prometheus ${name} exporter";
        enableLocalScraping = mkEnableOption "enable scraping by local prometheus";
        port = mkOption {
          type = types.port;
          default = 9732;
          description = ''
            Port to listen on.
          '';
        };
        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Address to listen on.
          '';
        };
        extraFlags = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Extra commandline options to pass to the ${name} exporter.
          '';
        };
        user = mkOption {
          type = types.str;
          default = "${name}-exporter";
          description = ''
            User name under which the ${name} exporter shall be run.
          '';
        };
        group = mkOption {
          type = types.str;
          default = "${name}-exporter";
          description = ''
            Group under which the ${name} exporter shall be run.
          '';
        };
      };
    };
    default = { };
  };
  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      description = "Prometheus ${name} exporter service user";
      isSystemUser = true;
      group = "${cfg.group}";
    };
    users.groups."${cfg.group}" = { };

    systemd.services."prometheus-${name}-exporter" = {
      environment = { };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.PrivateTmp = true;
      serviceConfig.WorkingDirectory = /tmp;
      serviceConfig.DynamicUser = false;
      serviceConfig.User = "${cfg.user}";
      serviceConfig.Group = "${cfg.group}";
      serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
      serviceConfig.ExecStart = ''
        ${getBin pkgs.prometheus-nftables-exporter}/bin/nftables_exporter ${concatStringsSep " " cfg.extraFlags} \
        --web.listen-address "${cfg.listenAddress}:${toString cfg.port}"
      '';
    };

    services.prometheus.scrapeConfigs = mkIf cfg.enableLocalScraping [
      {
        job_name = "${name}";
        honor_labels = true;
        static_configs = [{
          targets = [ "127.0.0.1:${toString cfg.port}" ];
        }];
      }
    ];
  };
}
