{ dnsData, ... }:
let
  s = x: [ x ];
  inherit (dnsData.digitalOcean) liamPublicV4 mailPublicV4 reservedV4;
in
{
  vacu.liamMail = true;
  vacu.defaultCAA = true;

  A = s mailPublicV4;
  subdomains = {
    do-a.A = s reservedV4;
    liam = {
      A = s reservedV4;
      vacu.liamMail = true;
    };
    mail = {
      A = s liamPublicV4;
      vacu.liamMail = true;
    };
    auwwth = {
      subdomains.ns.A = dnsData.awooA;
      NS = s "ns.auwwth.dis8.net.";
    };
    solis.A = dnsData.solisA;
    "_acme-challenge".CNAME = s "a55a31f9-74ac-44fc-bf97-c8c9f2498d3a.auth.dis8.net.";
  };
}
