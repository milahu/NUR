{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."pwrhs.win" =
    { ... }:
    {
      imports = [ dnsData.modules.cloudns ];
      A = singleton dnsData.tripPublicV4;
      subdomains.habitat.A = singleton dnsData.tripPublicV4;
      subdomains._acme-challenge.CNAME = singleton "73697955-1c51-48ba-ba1e-b3398850f59f.auwwth.dis8.net.";
    };
}
