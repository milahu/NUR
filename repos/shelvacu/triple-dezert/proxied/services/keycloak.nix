{ config, ... }:
let
  contain = config.containers.keycloak;
  settings = contain.config.services.keycloak.settings;
in
{
  vacu.databases.keycloak.fromContainer = "keycloak";

  vacu.proxiedServices.keycloak = {
    domain = settings.hostname;
    port = settings.http-port;
    forwardFor = true;
    fromContainer = "keycloak";
  };

  containers.keycloak = {
    privateNetwork = true;
    hostAddress = "192.168.100.14";
    localAddress = "192.168.100.15";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    config =
      { pkgs, ... }:
      {
        system.stateVersion = "23.11";
        networking.firewall.enable = false;

        #debugging
        environment.systemPackages = [ pkgs.inetutils ];

        services.keycloak = {
          enable = true;
          database.type = "postgresql";

          # most people would call this setting "bind address", keycloak is just dumb
          settings.http-host = contain.localAddress;
          settings.http-port = 80;
          settings.proxy = "edge";
          #todo: investigate any plugins i might want
          settings.hostname-strict-backchannel = false;
          settings.hostname = "auth.shelvacu.com";

          database.username = "keycloak";
          database.passwordFile = "/dev/null";
          database.name = "keycloak";
          database.host = contain.hostAddress;
          database.useSSL = false;
          database.createLocally = false;
          # database.createLocally = true;
        };
      };
  };
}
