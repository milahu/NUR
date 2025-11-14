{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."pwrhs.win" =
    { ... }:
    {
      vacu.defaultCAA = true;
      A = singleton dnsData.propPublicV4;
      subdomains.habitat.A = singleton dnsData.propPublicV4;
    };
}
