{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
  inherit (config.vacu.dnsData.digitalOcean) liamPublicV4 mailPublicV4 reservedV4;
in
{
  vacu.dns."dis8.net" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;

      A = singleton mailPublicV4;
      subdomains = {
        do-a.A = singleton reservedV4;
        liam = {
          A = singleton reservedV4;
          vacu.liamMail = true;
        };
        mail = {
          A = singleton liamPublicV4;
          vacu.liamMail = true;
        };
        auwwth = {
          subdomains.ns.A = singleton dnsData.awooV4;
          NS = singleton "ns.auwwth.dis8.net.";
        };
        solis.A = singleton config.vacu.hosts.solis.primaryIp;
        "_acme-challenge".CNAME = singleton "a55a31f9-74ac-44fc-bf97-c8c9f2498d3a.auth.dis8.net.";
      };
    };
}
