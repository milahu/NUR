# haproxy absolutely refuses to serve static files. how dare you even ask
#
# to build&copy to binary cache:
#   nix copy --to 'file:///trip/nix-binary-cache?parallel-compression=true&secret-key=/root/cache-priv-key.pem&want-mass-query=true&write-nar-listing=true' .#nixosConfigurations."compute-deck".config.system.build.toplevel
{ config, lib, ... }:
{
  vacu.proxiedServices.nix-cache = {
    domain = "nixcache.shelvacu.com";
    fromContainer = "nix-cache-nginx";
    port = 80;
  };
  containers.nix-cache-nginx = {
    privateNetwork = true;
    hostAddress = "192.168.100.12";
    localAddress = "192.168.100.13";

    autoStart = true;
    ephemeral = true;

    bindMounts."/www" = {
      hostPath = "/trip/nix-binary-cache";
      isReadOnly = true;
    };

    config =
      let
        container = config.containers.nix-cache-nginx;
      in
      {
        system.stateVersion = "23.11";
        networking.firewall.enable = false;
        services.nginx.enable = true;
        services.nginx.virtualHosts.binary-cache = {
          root = "/www/";
          listenAddresses = [ container.localAddress ];
          default = true;
        };
      };
  };
  vacu.nix.caches.vacu.url =
    lib.mkForce "file:///trip/nix-binary-cache?priority=5&want-mass-query=true";
}
