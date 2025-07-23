{ config, ... }:
let
  container = config.containers.mira-wisdom;
  dbCfg = config.vacu.databases.mira-wisdom;
  domain = "wisdom.for.miras.pet";
  auth_domain = "auth.for.miras.pet";
  port = 3000;
in
{
  vacu.databases.mira-wisdom = {
    fromContainer = "mira-wisdom";
  };

  vacu.proxiedServices.mira-wisdom = {
    inherit domain port;
    fromContainer = "mira-wisdom";
    forwardFor = true;
    maxConnections = 100;
  };

  containers.mira-wisdom = {
    privateNetwork = true;
    hostAddress = "192.168.100.42";
    localAddress = "192.168.100.43";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    config =
      { lib, ... }:
      {
        system.stateVersion = "24.11";

        nixpkgs.config.allowUnfree = true;

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        services.outline = {
          enable = true;
          concurrency = 3;
          databaseUrl = "postgres://${dbCfg.user}@${container.hostAddress}/${dbCfg.name}";
          defaultLanguage = "en_US";
          forceHttps = false; # this is reverse proxy's job
          oidcAuthentication = rec {
            displayName = "Mira Cult SSO";
            clientId = "outline";
            clientSecretFile = "/var/lib/outline/client_secret";
            authUrl = "https://${auth_domain}/ui/oauth2";
            tokenUrl = "https://${auth_domain}/oauth2/token";
            userinfoUrl = "https://${auth_domain}/oauth2/openid/${clientId}/userinfo";
          };
          inherit port;
          publicUrl = "https://${domain}";
          storage.storageType = "local";
        };

        systemd.services.outline.serviceConfig.Environment = [ "PGSSLMODE=disable" ];
      };
  };
}
