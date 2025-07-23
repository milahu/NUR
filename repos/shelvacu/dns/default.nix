{
  dns,
  lib,
  vaculib,
  config,
  ...
}:
let
  inherit (lib) mkOption types singleton;
  inherit (vaculib) mkOutOption;
  inherit (dns.lib.combinators)
    spf
    mx
    ttl
    ns
    ;
  cfg = config.vacu.dnsData;
in
{
  imports = [
    ./jean-luc.org.nix
    ./pwrhs.win.nix
    ./shelvacu.miras.pet.nix
    ./for.miras.pet.nix
    ./shelvacu.com.nix
  ];
  options.vacu.dns = mkOption {
    default = { };
    type = types.attrsOf dns.lib.types.zone;
  };
  options.vacu.dnsData = {
    tripPublicV4 = mkOutOption "172.83.159.53";
    propPublicV4 = mkOutOption "205.201.63.13";
    cloudnsNameServers = mkOutOption [
      "pns51.cloudns.net."
      "pns52.cloudns.net."
      "pns53.cloudns.net."
      "pns54.cloudns.net."
    ];
    cloudnsSoa = mkOutOption (
      ttl (60 * 60) {
        nameServer = lib.head cfg.cloudnsNameServers;
        adminEmail = "support@cloudns.net";
        serial = 1970010101; # cloudns takes care of updating the serial
        refresh = 7200;
        retry = 1800;
        expire = 1209600;
        minimum = 3600;
      }
    );
    dkimKeys.liam = mkOutOption {
      name = "2024-03-liam";
      content = "v=DKIM1; k=rsa; s=email; p=MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAqoFR9cwOb+IpvaqrI55zlouWMUk5hjKHQARajqeOev2I6Gc3QIvU8btyhKCJu7pwxr+DxK/9HeqTmweCSXZmLlVZ6LjW80aAg+8l2DyMKZPaTowSQcExfNMwHqI1ByUPx49LQQEzvwv8Lx3To2+JghZNXHUx7gcraoCUQnRNzCMoMsGF25Yyt4piW6SXKWsbWHVXaL2i953PtT6agJYqssnBqPx6wqibrkeB9MbtSw97L5oQDaDLmJzEK54vRjFFV4X6/Q1d3D6M5PH0XGm6WEhrNEPgMAAZ6rBqi+AoXUz9E9B+kE/Zc6krCTiV0Y1uL83RCILaEJIjRsHqgrGRYEIBUb4Z5d4CgB3szixzaFTmG+XAgDLGnAHRNGeOn0bUmj35miLUopzGJgHCUQYjaaXMH4FSQMYBFPVqZ1aSiZO0EC/mbLlFbBy51RYPJQK0IusN4IqaBYw6jZYMEVlLWkNb34bfNtPKwoG4T3UjxmSRpfiNCFjYd4DaOz/FBAvUL9bx+qU7O6EZRtslROaWN18uSt20hBH0SpvEovj7vBgWWqXG/chNS7YSSaf3Tlb3I5NbqbmvwFF0t8uuEtN0Wh26qMuOKx70K90B9FpJBpfIk/w8FQ80kP6spbMN1v1T5fA7oZMV1fOn1IezH4wE5Yk/3dS+OXJ4YiLH/hWfjecCAwEAAQ==";
    };
    modules.cloudns = mkOutOption {
      SOA = cfg.cloudnsSoa;
      NS = map (s: ttl (60 * 60) (ns s)) cfg.cloudnsNameServers;
      TTL = lib.mkDefault 300;
    };
    modules.liamMail = mkOutOption {
      MX = singleton (mx.mx 0 "liam.dis8.net.");
      TXT = singleton (
        spf.strict [
          "mx"
          "include:outbound.mailhop.org"
          "include:_spf.mailersend.net"
          "a:relay.dynu.com"
        ]
      );
      subdomains."${cfg.dkimKeys.liam.name}._domainkey".TXT = singleton cfg.dkimKeys.liam.content;
    };
  };
}
