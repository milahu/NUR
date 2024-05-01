# TODO: split this file apart into smaller files to make it easier to understand
{ config, lib, pkgs, ... }:

let
  dyn-dns = config.sane.services.dyn-dns;
  nativeAddrs = lib.mapAttrs (_name: builtins.head) config.sane.dns.zones."uninsane.org".inet.A;
  bindOvpn = "10.0.1.5";
in
{
  sane.ports.ports."53" = {
    protocol = [ "udp" "tcp" ];
    visibleTo.lan = true;
    visibleTo.wan = true;
    visibleTo.ovpn = true;
    description = "colin-dns-hosting";
  };

  sane.dns.zones."uninsane.org".TTL = 900;

  # SOA record structure: <https://en.wikipedia.org/wiki/SOA_record#Structure>
  # SOA MNAME RNAME (... rest)
  # MNAME = Master name server for this zone. this is where update requests should be sent.
  # RNAME = admin contact (encoded email address)
  # Serial = YYYYMMDDNN, where N is incremented every time this file changes, to trigger secondary NS to re-fetch it.
  # Refresh = how frequently secondary NS should query master
  # Retry = how long secondary NS should wait until re-querying master after a failure (must be < Refresh)
  # Expire = how long secondary NS should continue to reply to queries after master fails (> Refresh + Retry)
  sane.dns.zones."uninsane.org".inet = {
    SOA."@" = ''
      ns1.uninsane.org. admin-dns.uninsane.org. (
                                      2023092101 ; Serial
                                      4h         ; Refresh
                                      30m        ; Retry
                                      7d         ; Expire
                                      5m)        ; Negative response TTL
    '';
    TXT."rev" = "2023092101";

    CNAME."native" = "%CNAMENATIVE%";
    A."@" =      "%ANATIVE%";
    A."servo.wan" = "%AWAN%";
    A."servo.lan" = config.sane.hosts.by-name."servo".lan-ip;
    A."servo.hn" = config.sane.hosts.by-name."servo".wg-home.ip;

    # XXX NS records must also not be CNAME
    # it's best that we keep this identical, or a superset of, what org. lists as our NS.
    # so, org. can specify ns2/ns3 as being to the VPN, with no mention of ns1. we provide ns1 here.
    A."ns1" =    "%ANATIVE%";
    A."ns2" =    "185.157.162.178";
    A."ns3" =    "185.157.162.178";
    A."ovpns" =  "185.157.162.178";
    NS."@" = [
      "ns1.uninsane.org."
      "ns2.uninsane.org."
      "ns3.uninsane.org."
    ];
  };

  services.trust-dns.settings.zones = [ "uninsane.org" ];


  networking.nat.enable = true;
  networking.nat.extraCommands = ''
    # redirect incoming DNS requests from LAN addresses
    #   to the LAN-specialized DNS service
    # N.B.: use the `nixos-*` chains instead of e.g. PREROUTING
    #   because they get cleanly reset across activations or `systemctl restart firewall`
    #   instead of accumulating cruft
    iptables -t nat -A nixos-nat-pre -p udp --dport 53 \
      -m iprange --src-range 10.78.76.0-10.78.79.255 \
      -j DNAT --to-destination :1053
    iptables -t nat -A nixos-nat-pre -p tcp --dport 53 \
      -m iprange --src-range 10.78.76.0-10.78.79.255 \
      -j DNAT --to-destination :1053
  '';
  sane.ports.ports."1053" = {
    # because the NAT above redirects in nixos-nat-pre, LAN requests behave as though they arrived on the external interface at the redirected port.
    # TODO: try nixos-nat-post instead?
    # TODO: or, don't NAT from port 53 -> port 1053, but rather nat from LAN addr to a loopback addr.
    # - this is complicated in that loopback is a different interface than eth0, so rewriting the destination address would cause the packets to just be dropped by the interface
    protocol = [ "udp" "tcp" ];
    visibleTo.lan = true;
    description = "colin-redirected-dns-for-lan-namespace";
  };


  sane.services.trust-dns.enable = true;
  sane.services.trust-dns.instances = let
    mkSubstitutions = flavor: {
      "%AWAN%" = "$(cat '${dyn-dns.ipPath}')";
      "%CNAMENATIVE%" = "servo.${flavor}";
      "%ANATIVE%" = nativeAddrs."servo.${flavor}";
      "%AOVPNS%" = "185.157.162.178";
    };
  in
  {
    wan = {
      substitutions = mkSubstitutions "wan";
      listenAddrs = [
        nativeAddrs."servo.lan"
        bindOvpn
      ];
    };
    lan = {
      substitutions = mkSubstitutions "lan";
      listenAddrs = [ nativeAddrs."servo.lan" ];
      port = 1053;
    };
    hn = {
      substitutions = mkSubstitutions "hn";
      listenAddrs = [ nativeAddrs."servo.hn" ];
      port = 1053;
    };
    hn-resolver = {
      # don't need %AWAN% here because we forward to the hn instance.
      listenAddrs = [ nativeAddrs."servo.hn" ];
      extraConfig = {
        zones = [
          {
            zone = "uninsane.org";
            zone_type = "Forward";
            stores = {
              type = "forward";
              name_servers = [
                {
                  socket_addr = "${nativeAddrs."servo.hn"}:1053";
                  protocol = "udp";
                  trust_nx_responses = true;
                }
              ];
            };
          }
          {
            # forward the root zone to the local DNS resolver
            zone = ".";
            zone_type = "Forward";
            stores = {
              type = "forward";
              name_servers = [
                {
                  socket_addr = "127.0.0.53:53";
                  protocol = "udp";
                  trust_nx_responses = true;
                }
              ];
            };
          }
        ];
      };
    };
  };

  sane.services.dyn-dns.restartOnChange = [
    "trust-dns-wan.service"
    "trust-dns-lan.service"
    "trust-dns-hn.service"
    # "trust-dns-hn-resolver.service"  # doesn't need restart because it doesn't know about WAN IP
  ];
}
