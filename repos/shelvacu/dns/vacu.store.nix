{ lib, config, ... }:
let
  inherit (lib) singleton;
  s = singleton;
  inherit (config.vacu) dnsData;
  trip_ips = s dnsData.tripPublicV4;
  prop_ips = s dnsData.propPublicV4;
in
{
  vacu.dns."vacu.store" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;
      A = trip_ips;
      subdomains = {
        _acme-challenge.CNAME = s "83895c55-d556-40c5-b41b-d55a312d99f9.auwwth.dis8.net.";
        www.A = trip_ips;
      };
    };
}
