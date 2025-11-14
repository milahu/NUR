{ config, vacuModules, ... }:
{
  imports = [ vacuModules.garage ];
  vacu.garage = {
    rpcPort = 9060;
    dataDir = "/propdata/garage-data";
    capacity = "10T";
  };

  services.garage.settings.s3_api.root_domain = ".s3.garage.prophecy.shelvacu.com";

  users.users.${config.services.caddy.user}.extraGroups = [
    "garage-sockets"
    "garage"
  ];

  services.caddy.virtualHosts = {
    "s3.garage.prophecy.shelvacu.com" = {
      vacu.hsts = "preload";
      extraConfig = ''
        reverse_proxy unix/${config.vacu.garage.sockets.s3}
      '';
    };
    "admin.garage.prophecy.shelvacu.com" = {
      vacu.hsts = "preload";
      extraConfig = ''
        reverse_proxy unix/${config.vacu.garage.sockets.admin}
      '';
    };
  };
}
