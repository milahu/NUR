{ persistence, ... }: {
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard = {
      # Only enable wireguard if we're persisting data (thus, have the key)
      enable = persistence;
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.3/24" "fdc9:281f:04d7:9ee9::3/64" ];
          listenPort = 51820;
          privateKeyFile = "/persist/etc/wireguard/private.key";
          peers = [{
            publicKey = "a3dmQRbDmCeWEUyiUxAIjoI5icfzw8llKv5BHTgCJw8=";
            allowedIPs = [
              # Local net IPs
              "192.168.77.0/24"
              "2804:14d:8084:a484::/64"
              # Wireguard IPs
              "10.100.0.0/24"
              "fdc9:281f:04d7:9ee9::/64"
              # Multicast IPs
              "224.0.0.251/32"
              "ff02::fb/128"
            ];
            endpoint = "home.misterio.me:51820";
            dynamicEndpointRefreshSeconds = 25;
            persistentKeepalive = 25;
          }];
          postSetup = ''
            ip link set wg0 multicast on
          '';
        };
      };
    };
  };
}
