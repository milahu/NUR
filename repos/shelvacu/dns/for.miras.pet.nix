{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."for.miras.pet" =
    { ... }:
    {
      imports = [ dnsData.modules.cloudns ];
      SOA.minimum = lib.mkForce 60;
      subdomains = {
        "git".A = singleton dnsData.tripPublicV4;
        "auth".A = singleton dnsData.tripPublicV4;
        "wisdom".A = singleton dnsData.tripPublicV4;
        "chat" =
          { ... }:
          {
            imports = [ dnsData.modules.liamMail ];
            config.A = singleton dnsData.tripPublicV4;
            config.subdomains."duo-1745490301302-14f65157._domainkey".TXT =
              singleton "v=DKIM1; k=rsa; s=email; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDA/94Rh5eMPsKwGGolkleY1Rhh2Q6H22bfdGVu0lXpoHP1K7JxloWu/Ice2vVN/udztmPY+BK1x+5qubcGZKpPt1bC9amsXnyTXfKIMGD2CNd0tnaO54hmMOfv+lTA9YjF0X93tcQP3yUxJgJ9yPZcalFl/bBAqv4/lUVLYFeIVQIDAQAB";
          };
        "gabriel-dropout".A = singleton dnsData.tripPublicV4;
        "_acme-challenge".CNAME = singleton "199b8aa4-bc9f-4f43-88bf-3f613f62b663.auwwth.dis8.net.";
      };
    };
}
