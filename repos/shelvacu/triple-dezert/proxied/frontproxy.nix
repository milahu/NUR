{
  config,
  pkgs,
  lib,
  ...
}:
let
  # How to register a new domain in acme-dns before deploying the nix config:
  # From trip:
  #   curl http://10.16.237.1/register -X POST
  # add it to /var/lib/acme/.lego/lego-acme-dns-accounts.json
  # add CNAME record that points _acme-challenge.whatever.domain to "fulldomain"
  domains = [
    "shelvacu.com"
    "vacu.store"
    "jean-luc.org"
    "pwrhs.win"
    "jf.finaltask.xyz"
    "shelvacu.miras.pet"
    "for.miras.pet"
  ];
  proxied = lib.pipe config.vacu.proxiedServices [
    lib.attrValues
    (lib.filter (c: c.enable))
  ];
  serviceValidDomainAssertions = map (proxiedConfig: {
    assertion = lib.any (
      availableDomain:
      (lib.hasSuffix ("." + availableDomain) proxiedConfig.domain)
      || (proxiedConfig.domain == availableDomain)
    ) domains;
    message = "proxiedService ${proxiedConfig.name}'s `domain` does not match any of the known domains";
  }) proxied;
  #networking.hosts = mapListToAttrs (c: lib.nameValuePair c.ipAddress [ c.name ]) proxied;
  hosts = lib.foldl (
    acc: c:
    let
      name = c.ipAddress;
      val = c.name;
    in
    acc // { ${name} = (acc.${name} or [ ]) ++ [ val ]; }
  ) { } proxied;
  mapListToAttrs = f: list: lib.listToAttrs (map f list);
in
{
  assertions = [ ] ++ serviceValidDomainAssertions;
  security.acme.acceptTerms = true;
  security.acme.defaults = {
    email = "nix-acme@shelvacu.com";
    dnsProvider = "acme-dns";
    environmentFile = pkgs.writeText "acme-dns-config.env" ''
      ACME_DNS_API_BASE=http://10.16.237.1
      ACME_DNS_STORAGE_PATH=/var/lib/acme/.lego/lego-acme-dns-accounts.json
    '';
    postRun = "${pkgs.nixos-container}/bin/nixos-container run frontproxy -- systemctl reload haproxy";
  };

  security.acme.certs = mapListToAttrs (
    domain: lib.nameValuePair domain { extraDomainNames = [ "*.${domain}" ]; }
  ) domains;

  users.groups.acme.gid = 993;

  systemd.services."containers@frontproxy" = {
    wants = [ "network.target" ];
    after = [ "network.target" ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ]; # quic!

  containers.frontproxy =
    let
      outer_config = config;
    in
    {
      autoStart = true;
      restartIfChanged = true;
      ephemeral = true;
      bindMounts = mapListToAttrs (
        d:
        lib.nameValuePair "/certs/${d}" {
          hostPath = outer_config.security.acme.certs.${d}.directory;
          isReadOnly = true;
        }
      ) domains;
      config =
        { config, ... }:
        {
          system.stateVersion = "23.11";
          users.groups.acme.gid = outer_config.users.groups.acme.gid;
          users.users.haproxy.extraGroups = [ config.users.groups.acme.name ];
          services.haproxy.enable = true;
          services.haproxy.config = import ./haproxy-config.nix { inherit lib domains proxied; };
          networking.hosts = hosts;
          systemd.tmpfiles.settings."asdf"."/run/haproxy".D = {
            user = "haproxy";
            group = "haproxy";
            mode = "700";
          };
        };
    };
}
