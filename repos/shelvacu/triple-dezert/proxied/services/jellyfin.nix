{ ... }:
let
  name = "jellyfin";
in
{
  systemd.tmpfiles.settings.${name}."/trip/${name}".d = {
    mode = "0755";
  };

  vacu.proxiedServices.${name} = {
    domain = "jf.finaltask.xyz";
    fromContainer = name;
    port = 8096;
    maxConnections = 100;
  };

  containers.${name} = {
    privateNetwork = true;
    hostAddress = "192.168.100.22";
    localAddress = "192.168.100.23";

    autoStart = true;
    ephemeral = true;
    restartIfChanged = true;
    bindMounts."/${name}" = {
      hostPath = "/trip/${name}";
      isReadOnly = false;
    };

    config =
      { pkgs, config, ... }:
      {
        system.stateVersion = "24.05";

        networking.useHostResolvConf = false;
        networking.nameservers = [ "10.78.79.1" ];
        networking.firewall.enable = false;

        services.jellyfin = {
          enable = true;
          dataDir = "/${name}";
        };

        environment.systemPackages = [
          config.services.jellyfin.package
          pkgs.jellyfin-web
          pkgs.jellyfin-ffmpeg
        ];
      };
  };
}
