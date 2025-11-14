{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
  trip_ips = singleton dnsData.tripPublicV4;
  prop_ips = singleton dnsData.propPublicV4;
in
{
  vacu.dns."jean-luc.org" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;
      A = prop_ips;
      NS = lib.mkAfter [ "ns2.afraid.org." ]; # note: appends to NS records from modules.cloudns
      subdomains = {
        "in".vacu.liamMail = true;
        # "*".A = main_ips;
        "_acme-challenge".CNAME = singleton "8cc7a174-c4a6-40f5-9fff-dfb271c5ce0b.auwwth.dis8.net.";
        "stats".A = prop_ips;
        "tdi-readings".CNAME = singleton "d20l6bh1gp7s8.cloudfront.net.";
        "_a908498ee692a9729bf12e161ae1887d.tdi-readings".CNAME =
          singleton "_1f055e4fc0f439e67304a33945d09002.hkvuiqjoua.acm-validations.aws.";
        www.A = prop_ips;
      };
    };
}
