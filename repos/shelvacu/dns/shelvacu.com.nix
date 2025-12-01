{
  dnsData,
  lib,
  vaculib,
  outerConfig,
  ...
}:
let
  s = v: [ v ];
  inherit (dnsData) tripA propA solisA;
  # mail_thing = s "178.128.79.152";
  mail_thing = s dnsData.digitalOcean.liamPublicV4;
  # which domains to allow dmarc reports.
  # ex: _dmarc.dis8.net TXT has "rua=rua-reports@shelvacu.com", reports will only be sent if shelvacu.com allows them
  # allow all domains configured in this repo, and one level of subdomain (ideally all but thats hard, this should be good enough)
  allow_report_domains = lib.pipe outerConfig.vacu.dns [
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
  vacu.liamMail = true;
  vacu.defaultCAA = true;
  A = propA;
  subdomains = {
    _acme-challenge.CNAME = s "5cb20bf7-5203-417f-b729-fa3a3ad3b775.auwwth.dis8.net.";
    _atproto.TXT = s "did=did:plc:oqenurzqeji6ulii3myxls64";
    "_report._dmarc".subdomains = vaculib.mapNamesToAttrsConst {
      TXT = s "v=DMARC1";
    } allow_report_domains;
    "2e14".A = propA;
    f.A = propA;
    files.A = propA;
    copy.A = propA;
    copyparty.A = propA;
    actual.A = propA;
    admin-garage-trip.A = tripA;
    auth.A = tripA;
    autoconfig.A = mail_thing;
    awoo.A = s "45.142.157.71";
    dav-experiment.A = propA;
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
    id.A = propA;
    imap.A = mail_thing;
    jf.A = propA;
    jelly.A = propA;
    jellyfin.A = propA;
    jobs.A = propA;
    llm.A = tripA;
    mail.A = mail_thing;
    # mlsend2.subdomains._domainkey.CNAME = s "mlsend2._domainkey.mailersend.net.";
    mumble.A = propA;
    nitter.A = propA;
    nixcache.A = propA;
    ns1.CNAME = s "pns51.cloudns.net.";
    ns2.CNAME = s "pns52.cloudns.net.";
    ns3.CNAME = s "pns53.cloudns.net.";
    ns4.CNAME = s "pns54.cloudns.net.";
    powerhouse.CNAME = s "powerhouse.dyn.74358228.xyz.";
    prop.CNAME = s "prophecy";
    prophecy.A = propA;
    prophecy.subdomains."*".A = propA;
    "*.prophecy".A = propA;
    "s3.garage.prophecy".A = propA;
    "admin.garage.prophecy".A = propA;
    rad.A = tripA;
    radicale.A = propA;
    s3-garage-trip.A = tripA;
    servacu.A = s "167.99.161.174";
    smtp.A = mail_thing;
    sol.CNAME = s "solis";
    solis.A = solisA;
    solis.subdomains.garage.subdomains = {
      s3.A = solisA;
      admin.A = solisA;
    };
    trip.A = tripA;
    vaultwarden.A = propA;
    www.A = propA;
    xs.A = solisA;
  };
}
