{ lib, persistence, ... }: {
  services.deluge = {
    enable = true;
  };

  networking.firewall = {
    # Remote control port (not port forwarded)
    allowedTCPPorts = [ 58846 ];
    allowedUDPPorts = [ 58846 ];
    # Torrent connection ports (port forwarded)
    allowedTCPPortRanges = [{ from = 6880; to = 6890; }];
    allowedUDPPortRanges = [{ from = 6880; to = 6890; }];
  };

  environment.persistence = lib.mkIf persistence {
    "/persist".directories = [ "/var/lib/deluge" ];
  };
}
