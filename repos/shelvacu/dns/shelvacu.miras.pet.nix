{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."shelvacu.miras.pet" =
    { ... }:
    {
      imports = [
        dnsData.modules.cloudns
        dnsData.modules.liamMail
      ];
      A = singleton dnsData.tripPublicV4;
      subdomains."_acme-challenge".CNAME =
        singleton "65e44f64-3c65-46f6-b15f-4ad6363b21eb.auwwth.dis8.net.";
    };
}
