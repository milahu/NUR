{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.multicast-relay;
in
{
  options.services.multicast-relay = with types; mkOption {
    type = types.submodule {
      options = {
        enable = mkEnableOption "multicast-relay";
        interfaces = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Interfaces to listen on
          '';
        };
        extraConfig = mkOption {
          type = types.str;
          default = "";
          description = ''
            Extra config to apply
          '';
        };
        user = mkOption {
          type = str;
          default = "multicast-relay";
          description = ''
            User to run the service under
          '';
        };
        group = mkOption {
          type = str;
          default = "multicast-relay";
          description = ''
            Group of user to run the service under
          '';
        };

      };
    };
  };

  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      description = "multicast-relay user";
      isSystemUser = true;
      group = "${cfg.group}";
    };
    users.groups."${cfg.group}" = { };

    systemd.services."multicast-relay" = {
      environment = { };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.PrivateTmp = true;
      serviceConfig.WorkingDirectory = /tmp;
      serviceConfig.DynamicUser = false;
      serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" "CAP_NET_BROADCAST" "CAP_NET_RAW" ];
      serviceConfig.User = "${cfg.user}";
      serviceConfig.Group = "${cfg.group}";
      serviceConfig.ExecStart = ''
        ${getBin pkgs.multicast-relay}/bin/multicast-relay \
        --interfaces ${builtins.concatStringsSep " " cfg.interfaces} \
        --foreground \
        ${cfg.extraConfig}
      '';
    };
  };
}
