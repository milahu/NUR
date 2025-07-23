{ config, ... }:
let
  webListenPort = 8443;
  webListenIP = "127.4.20.165";
in
{
  networking.firewall.allowedTCPPorts = [ 636 ];

  vacu.databases.kanidm = {
    authByUser = true;
  };

  vacu.proxiedServices.kanidm = {
    domain = "id.shelvacu.com";
    forwardFor = true;
    useSSL = true;
    port = webListenPort;
    ipAddress = webListenIP;
  };

  environment.systemPackages = [ config.services.kanidm.package ]; # adds the binary to the PATH

  systemd.mounts = [
    {
      what = "/trip/sqlites/kani";
      where = builtins.dirOf config.services.kanidm.serverSettings.db_path;
      type = "none";
      options = "bind";
    }
  ];

  users.users.kanidm.extraGroups = [ "acme" ];

  services.kanidm =
    let
      tls_dir = config.security.acme.certs."shelvacu.com".directory;
    in
    rec {
      enableServer = true;
      serverSettings = {
        domain = "id.shelvacu.com";
        origin = "https://id.shelvacu.com";
        # db_path = "/trip/sqlites/kani/kani.sqlite";
        db_fs_type = "zfs";
        bindaddress = "${webListenIP}:${builtins.toString webListenPort}";
        ldapbindaddress = "[::]:636";
        trust_x_forward_for = true;
        tls_chain = tls_dir + "/fullchain.pem";
        tls_key = tls_dir + "/key.pem";
      };

      enableClient = true;
      clientSettings = {
        uri = serverSettings.origin;
        verify_ca = true;
        verify_hostnames = true;
      };
    };
}
