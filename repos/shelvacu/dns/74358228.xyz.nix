{ lib, config, ... }:
let
  inherit (lib) singleton;
  s = singleton;
  inherit (config.vacu) dnsData;
  trip_ips = s dnsData.tripPublicV4;
  prop_ips = s dnsData.propPublicV4;
in
{
  vacu.dns."74358228.xyz" =
    { ... }:
    {
      vacu.liamMail = false;
      vacu.defaultCAA = true;
      A = prop_ips;
      subdomains = {
        www.A = prop_ips;
        dyn.NS = [
          "pns51.cloudns.net."
          "pns52.cloudns.net."
          "pns53.cloudns.net."
          "pns54.cloudns.net."
        ];
        test.TXT = [ "aaaaaa" ];
      };
    };
}
