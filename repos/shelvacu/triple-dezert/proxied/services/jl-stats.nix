{
  config,
  inputs,
  pkgs,
  ...
}:
let
  name = "jl-stats";
  contain = config.containers.${name};
  most-winningest = inputs.most-winningest.packages."${pkgs.system}".default;
in
{
  vacu.databases.${name}.fromContainer = name;
  vacu.proxiedServices.${name} = {
    domain = "stats.jean-luc.org";
    fromContainer = name;
    port = 80;
  };

  systemd.tmpfiles.settings.${name}."/trip/${name}".d = {
    mode = "0755";
  };

  containers.${name} = {
    privateNetwork = true;
    hostAddress = "192.168.100.16";
    localAddress = "192.168.100.17";

    autoStart = true;
    ephemeral = true;
    restartIfChanged = true;
    bindMounts."/${name}" = {
      hostPath = "/trip/${name}";
      isReadOnly = false;
    };

    config =
      { pkgs, ... }:
      {
        system.stateVersion = "23.11";

        networking.useHostResolvConf = false;
        networking.nameservers = [ "10.78.79.1" ];
        networking.firewall.enable = false;

        systemd.tmpfiles.settings.${name}."/${name}/generated".d = {
          mode = "0755";
        };

        services.nginx.enable = true;
        services.nginx.virtualHosts."stats.jean-luc.org" = {
          default = true;
          root = "/${name}/generated";
        };

        systemd.services.most-winningest = {
          environment = {
            DATABASE_URL = "postgres://${name}@${contain.hostAddress}/${name}";
          };
          script = ''
            cd ${most-winningest.src}
            ${
              pkgs.diesel-cli.override {
                sqliteSupport = false;
                mysqlSupport = false;
              }
            }/bin/diesel migration run --locked-schema
            cd /${name}
            ${most-winningest}/bin/${most-winningest.pname}
          '';
        };

        systemd.timers.most-winningest = {
          wantedBy = [ "multi-user.target" ];
          timerConfig.OnBootSec = "5m";
          timerConfig.OnUnitInactiveSec = "1h";
        };

        environment.systemPackages = [
          config.services.postgresql.package # provides psql binary, helpful for debugging
        ];
      };
  };
}
