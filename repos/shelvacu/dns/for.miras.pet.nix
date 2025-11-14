{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."for.miras.pet" =
    { ... }:
    {
      vacu.defaultCAA = true;
      A = singleton dnsData.propPublicV4;
      subdomains = {
        "git".A = singleton dnsData.propPublicV4;
        "auth".A = singleton dnsData.propPublicV4;
        "wisdom".A = singleton dnsData.propPublicV4;
        "chat" =
          { ... }:
          {
            config.vacu.liamMail = true;
            config.A = singleton dnsData.propPublicV4;
          };
        "gabriel-dropout".A = singleton dnsData.propPublicV4;
      };
    };
}
