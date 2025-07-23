{ inputs, ... }:
{
  vacu.proxiedServices.jobs = {
    domain = "jobs.shelvacu.com";
    fromContainer = "jobs";
    port = 80;
    forwardFor = true;
    maxConnections = 100;
  };

  containers.jobs = {
    privateNetwork = true;
    hostAddress = "192.168.100.34";
    localAddress = "192.168.100.35";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    config =
      { lib, ... }:
      {
        system.stateVersion = "24.11";

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        services.nginx = {
          enable = true;
          virtualHosts."jobs.shelvacu.com" = {
            root = "${inputs.self}/jobs/public";
            extraConfig = ''
              location = /email {
                default_type text/plain;
                return 200 "Thank you. Send an email with your job offer to jobs-81567@shelvacu.com";
              }
            '';
          };
        };
      };
  };
}
