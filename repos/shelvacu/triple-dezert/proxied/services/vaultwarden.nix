{ config, ... }:
let
  domain = "vaultwarden.shelvacu.com";
  port = 6969;
  container = config.containers.vaultwarden;
in
{
  vacu.proxiedServices.vaultwarden = {
    inherit domain port;
    fromContainer = "vaultwarden";
    forwardFor = true;
    maxConnections = 100;
  };

  containers.vaultwarden = {
    privateNetwork = true;
    hostAddress = "192.168.100.44";
    localAddress = "192.168.100.45";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    config =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        secrets_folder = "/var/lib/vaultwarden/secrets";
        env_path = "${secrets_folder}/env";
        services = [ "vaultwarden.service" ];
        inherit (config.systemd.services.vaultwarden.serviceConfig) User Group;
      in
      {
        system.stateVersion = "24.11";

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        environment.systemPackages = [ pkgs.sqlite-interactive ];

        systemd.tmpfiles.settings."69-fkoewp".${secrets_folder}.d = {
          group = Group;
          user = User;
        };

        systemd.services.make-vaultwarden-secrets = {
          serviceConfig = { inherit User Group; };
          before = services;
          requiredBy = services;
          script = ''
            set -euo pipefail
            function mkpass() {
              tr -dc 'A-F0-9' < /dev/urandom | head -c64
            }
            admin_token="$(mkpass)"

            umask 0077
            printf 'ADMIN_TOKEN=%s\n' "$admin_token" > ${lib.escapeShellArg env_path}
          '';
          unitConfig.ConditionPathExists = [
            "!${env_path}"
            secrets_folder
          ];
        };

        # systemd.services.vaultwarden.unitConfig.ConditionPathExists = [ env_path ];

        services.vaultwarden = {
          enable = true;
          # environmentFile = env_path;
          config = {
            DOMAIN = "https://${domain}";
            SIGNUPS_ALLOWED = false;
            ROCKET_ADDRESS = container.localAddress;
            ROCKET_PORT = port;
          };
        };
      };
  };
}
