{ config, ... }:
{
  services.mongodb = {
    enable = true;
  };

  environment.persistence."/persistent".directories = [
    {
      directory = config.services.mongodb.dbpath;
      user = config.services.mongodb.user;
      mode = "0700";
    }
    {
      directory = builtins.dirOf config.services.genieacs.jwtSecret.path;
      user = config.services.genieacs.user;
      group = config.services.genieacs.group;
      mode = "0700";
    }
    {
      directory = "/var/log/genieacs";
      user = config.services.genieacs.user;
      group = config.services.genieacs.group;
      mode = "0700";
    }
  ];

  services.genieacs = {
    mongodbConnectionUrl = "mongodb://127.0.0.1/genieacs";
    # debugFile = "/var/log/genieacs/debug.log";
    defaults.enable = true;
    cwmp.port = 4201;
    nbi.port = 4202;
    fs.port = 4203;
    ui.port = 4204;
  };

  # networking.firewall.allowedTCPPorts = [ 4201 4202 4203 4204 ];
}
