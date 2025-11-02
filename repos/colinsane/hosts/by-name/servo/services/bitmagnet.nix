# bitmagnet is a DHT crawler. it discovers publicly reachable torrents and indexes:
# - torrent's magnet URI
# - torrent's name
# - torrent's file list (the first 100 files, per torrent), including size and "type" (e.g. video)
# - seeder/leecher counts
# - torrent's size
# it provides a web UI to query these, especially a search form.
# data is stored in postgresql as `bitmagnet` db (`sudo -u bitmagnet psql`)
# after 30 days of operation:
# - 12m torrents discovered
# - 77GB database size  => 6500B per torrent
{ config, ... }:
{
  services.bitmagnet.enable = true;
  sane.netns.ovpns.services = [ "bitmagnet" ];
  sane.ports.ports."3334" = {
    protocol = [ "tcp" "udp" ];
    # visibleTo.ovpns = true;  #< not needed: it runs in the ovpns namespace
    description = "colin-bitmagnet";
  };

  services.bitmagnet.settings = {
    # dht_crawler.scaling_factor: how rapidly to crawl the DHT.
    #   influences number of worker threads, buffer sizes, etc.
    #   default: 10.
    #   docs claim "diminishing returns" above 10, but seems weakly confident about that.
    dht_crawler.scaling_factor = 64;
    # http_server.local_address: `$addr:$port` to `listen` to.
    # default is `:3333`, which listens on _all_ interfaces.
    # the http server exposes unprotected admin endpoints though, so restrict to private interfaces:
    http_server.local_address = "${config.sane.netns.ovpns.veth.netns.ipv4}:3333";
    # tmdb.enabled: whether to query The Movie DataBase to resolve filename -> movie title.
    #   default: true.
    #   docs claim 1 query per second rate limit, unless you supply your own API key.
    tmdb.enabled = false;
  };

  # bitmagnet web client
  # protected by passwd because it exposes some mutation operations:
  # - queuing "jobs"
  # - deleting torrent infos (in bulk)
  # it uses graphql for _everything_, so no easy way to disable just the mutations (and remove the password) AFAICT.
  services.nginx.virtualHosts."bitmagnet.uninsane.org" = {
    # basicAuth is cleartext user/pw, so FORCE this to happen over SSL
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${config.sane.netns.ovpns.veth.netns.ipv4}:3333";
      recommendedProxySettings = true;
    };
    basicAuthFile = config.sops.secrets.bitmagnet_passwd.path;
  };
  sops.secrets."bitmagnet_passwd" = {
    owner = config.users.users.nginx.name;
    mode = "0400";
  };

  sane.dns.zones."uninsane.org".inet.CNAME."bitmagnet" = "native";

  systemd.services.bitmagnet = {
    # hardening (systemd-analyze security bitmagnet). base nixos service is already partially hardened.
    serviceConfig.CapabilityBoundingSet = "";
    serviceConfig.SystemCallArchitectures = "native";
    serviceConfig.PrivateDevices = true;
    serviceConfig.PrivateUsers = true;
    serviceConfig.ProtectProc = "invisible";
    serviceConfig.ProcSubset = "pid";
    serviceConfig.SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  };
}
