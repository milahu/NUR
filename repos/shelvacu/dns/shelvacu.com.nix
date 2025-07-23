{
  lib,
  config,
  dns,
  ...
}:
let
  s = v: [ v ];
  inherit (config.vacu) dnsData;
  comb = dns.lib.combinators;
  trip_ips = s dnsData.tripPublicV4;
  prop_ips = s dnsData.propPublicV4;
  mail_thing = s "178.128.79.152";
in
{
  vacu.dns."shelvacu.com" =
    { ... }:
    {
      imports = [
        dnsData.modules.cloudns
        dnsData.modules.liamMail
      ];
      A = trip_ips;
      CAA = [
        {
          issuerCritical = false;
          tag = "issuewild";
          value = "letsencrypt.org;validationmethods=dns-01";
        }
        {
          issuerCritical = false;
          tag = "iodef";
          value = "mailto:caa-violation@shelvacu.com";
        }
      ];
      subdomains = {
        "*".A = trip_ips;
        # "2esrever.zt".A = s "10.244.46.71";
        auth.A = trip_ips;
        autoconfig.A = mail_thing;
        awoo.A = s "45.142.157.71";
        # "frosting.zt".A = [ "10.244.141.219" ];
        id.A = trip_ips;
        imap.A = mail_thing;
        mail.A = mail_thing;
        #"ms-7522.zt.shelvacu.com". clearly unused
        nixcache.A = trip_ips;
        #powerhouse: dynamic
        prop.A = prop_ips;
        prophecy.A = prop_ips;
        servacu.A = s "167.99.161.174";
        smtp.A = mail_thing;
        trip.A = trip_ips;
        ns1.CNAME = s "pns51.cloudns.net.";
        ns2.CNAME = s "pns52.cloudns.net.";
        ns3.CNAME = s "pns53.cloudns.net.";
        ns4.CNAME = s "pns54.cloudns.net.";
        _acme-challenge.CNAME = s "5cb20bf7-5203-417f-b729-fa3a3ad3b775.auwwth.dis8.net.";
        hzo3bcydh5khtpeio6zrzb7kwcwiccnh.subdomains._domainkey.CNAME = s "hzo3bcydh5khtpeio6zrzb7kwcwiccnh.dkim.amazonses.com.";
        mlsend2.subdomains._domainkey.CNAME = s "mlsend2._domainkey.mailersend.net.";
        # mta.CNAME = s "mailersend.net.";
        www.A = trip_ips;
        # skipping hosted-email-verify=y3cjgqb2
        _atproto.TXT = s "did=did:plc:oqenurzqeji6ulii3myxls64";
        _dmarc.TXT = s "v=DMARC1;p=reject;sp=reject;ruf=mailto:dmarc-ruf@shelvacu.com;rua=mailto:dmarc-rua@shelvacu.com";
        # "duo-1720147659938-f009dc8e._domainkey".TXT = "v=DKIM1; k=rsa; s=email; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyH6BNRePSuI7Vs+bPd1MfFSp+O0XkYLOF4j6azRp4a80vi9wOWcCO5PEMOt4nsepwp2WyV0u9N/8XWzBQEK5x2ABFkBkHwfzN6Afm9n6H6tOjNORhGP/cv2txiNhdoPamQdTttqrYZGYGxJyj5pSuc+cXNx5UxUr2a+FKdxuWewIDAQAB";
        ft.subdomains = {
          "*".A = s "45.87.250.193";
          _acme-challenge.CNAME = s "17aa43aa-9295-4522-8cf2-b94ba537753d.auth.acme-dns.io.";
        };
      };
    };
}
