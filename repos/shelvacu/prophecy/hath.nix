{ vacuModules, config, ... }:
let
  port = 62622;
in
{
  imports = [ vacuModules.hath ];
  sops.secrets.hathClientKey = {
    owner = config.vacu.hath.user;
    restartUnits = [ "hath.service" ];
  };
  vacu.hath = {
    enable = true;
    autoStart = true;
    flushLogs = true;
    allowPrivilegedPort = false;
    cacheDir = "/propdata/hath-cache";
    credentials = {
      clientId = 50751;
      clientKeyPath = config.sops.secrets.hathClientKey.path;
    };
  };
  environment.persistence."/persistent".directories = [
    {
      directory = "/var/lib/hath";
      user = config.vacu.hath.user;
      group = config.vacu.hath.group;
      mode = "u=rwx,g=,o=";
    }
  ];
  networking.firewall.allowedTCPPorts = [ port ];
}
