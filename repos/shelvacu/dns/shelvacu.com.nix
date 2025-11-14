{
  config,
  lib,
  vaculib,
  ...
}:
let
  s = v: [ v ];
  inherit (config.vacu) dnsData;
  trip_ips = s dnsData.tripPublicV4;
  prop_ips = s dnsData.propPublicV4;
  solis_ips = s config.vacu.hosts.solis.primaryIp;
  mail_thing = s "178.128.79.152";
  # which domains to allow dmarc reports.
  # ex: _dmarc.dis8.net TXT has "rua=rua-reports@shelvacu.com", reports will only be sent if shelvacu.com allows them
  # allow all domains configured in this repo, and one level of subdomain (ideally all but thats hard, this should be good enough)
  allow_report_domains = lib.pipe config.vacu.dns [
    lib.attrNames
    (
      list:
      list
      ++ [
        "theviolincase.com"
        "violingifts.com"
      ]
    )
    (lib.concatMap (domain: [
      domain
      "*.${domain}"
    ]))
  ];
in
{
  vacu.dns."shelvacu.com" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;
      A = prop_ips;
      subdomains = {
        _acme-challenge.CNAME = s "5cb20bf7-5203-417f-b729-fa3a3ad3b775.auwwth.dis8.net.";
        _atproto.TXT = s "did=did:plc:oqenurzqeji6ulii3myxls64";
        "_report._dmarc".subdomains = vaculib.mapNamesToAttrsConst {
          TXT = s "v=DMARC1";
        } allow_report_domains;
        "2e14".A = prop_ips;
        f.A = prop_ips;
        files.A = prop_ips;
        copy.A = prop_ips;
        copyparty.A = prop_ips;
        actual.A = prop_ips;
        admin-garage-trip.A = trip_ips;
        auth.A = trip_ips;
        autoconfig.A = mail_thing;
        awoo.A = s "45.142.157.71";
        dav-experiment.A = prop_ips;
        dynrecords.NS = [
          "pns51.cloudns.net."
          "pns52.cloudns.net."
          "pns53.cloudns.net."
          "pns54.cloudns.net."
        ];
        ft.subdomains = {
          "*".A = s "45.87.250.193";
          _acme-challenge.CNAME = s "17aa43aa-9295-4522-8cf2-b94ba537753d.auth.acme-dns.io.";
        };
        # hzo3bcydh5khtpeio6zrzb7kwcwiccnh.subdomains._domainkey.CNAME = s "hzo3bcydh5khtpeio6zrzb7kwcwiccnh.dkim.amazonses.com.";
        id.A = prop_ips;
        imap.A = mail_thing;
        jf.A = prop_ips;
        jelly.A = prop_ips;
        jellyfin.A = prop_ips;
        jobs.A = prop_ips;
        llm.A = trip_ips;
        mail.A = mail_thing;
        # mlsend2.subdomains._domainkey.CNAME = s "mlsend2._domainkey.mailersend.net.";
        mumble.A = prop_ips;
        nitter.A = prop_ips;
        nixcache.A = prop_ips;
        ns1.CNAME = s "pns51.cloudns.net.";
        ns2.CNAME = s "pns52.cloudns.net.";
        ns3.CNAME = s "pns53.cloudns.net.";
        ns4.CNAME = s "pns54.cloudns.net.";
        powerhouse.CNAME = s "powerhouse.dyn.74358228.xyz.";
        prop.CNAME = s "prophecy";
        prophecy.A = prop_ips;
        prophecy.subdomains."*".A = prop_ips;
        "*.prophecy".A = prop_ips;
        "s3.garage.prophecy".A = prop_ips;
        "admin.garage.prophecy".A = prop_ips;
        rad.A = trip_ips;
        radicale.A = prop_ips;
        s3-garage-trip.A = trip_ips;
        servacu.A = s "167.99.161.174";
        smtp.A = mail_thing;
        sol.CNAME = s "solis";
        solis.A = solis_ips;
        solis.subdomains.garage.subdomains = {
          s3.A = solis_ips;
          admin.A = solis_ips;
        };
        trip.A = trip_ips;
        vaultwarden.A = prop_ips;
        www.A = prop_ips;
        xs.A = solis_ips;
      };
    };
}
