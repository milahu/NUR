## config
# - <https://knot-resolver.readthedocs.io/en/stable/config-overview.html>
{ config, lib, ... }:
let
  hostCfg = config.sane.hosts.by-name."${config.networking.hostName}" or null;
in
{
  config = lib.mkIf (!config.sane.services.hickory-dns.asSystemResolver) {
    services.resolved.enable = lib.mkForce false;

    networking.nameservers = [
      # be compatible with systemd-resolved
      # "127.0.0.53"
      # or don't be compatible with systemd-resolved, but with libc and pasta instead
      #   see <pkgs/by-name/sane-scripts/src/sane-vpn>
      "127.0.0.1"
      # enable IPv6, or don't; unbound is spammy when IPv6 is enabled but unroutable
      # "::1"
    ];

    networking.resolvconf.useLocalResolver = false;  #< we manage resolvconf explicitly, above
    networking.resolvconf.extraConfig = ''
      # DNS serviced by `kresd` (knot-resolver) recursive resolver
      name_servers='127.0.0.1'
    '';

    sane.persist.sys.byPath."/var/cache/knot-resolver" = {
      # TODO: store the cache in private store, and restart the service once that's been unlocked?
      store = "plaintext";
      method = "bind";
      acl.mode = "0770";
      acl.user = "knot-resolver";
    };

    services.kresd.enable = true;
    services.kresd.listenPlain = [
      "127.0.0.1:53"
    ] ++ lib.optionals (hostCfg != null && hostCfg.wg-home.ip != null) [
      # allow wireguard clients to use us as a recursive resolver (only needed for servo)
      "${hostCfg.wg-home.ip}:53"
    ];

    # TODO:
    # - [x] disable DNSSEC
    # - [ ] IPv4-only
    # - [ ] serve tailscale records
    # - [ ] persist the on-disk cache
    # - [ ] integrate with dhcp-configs
    services.kresd.extraConfig = ''
      -- config docs: <https://www.knot-resolver.cz/documentation/stable/config-overview.html>

      -- we can't guarantee that all forwarders support DNSSEC.
      -- replicating my bind config, and just disabling dnssec universally
      -- dnssec = false
      -- trust_anchors.remove('.')

      net.ipv6 = false
    '';
  };
}
