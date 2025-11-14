{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."shelvacu.miras.pet" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;
      A = singleton dnsData.propPublicV4;
    };
}
