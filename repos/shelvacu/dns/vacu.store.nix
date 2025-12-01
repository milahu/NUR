{ dnsData, ... }:
let
  inherit (dnsData) tripA;
in
{
  vacu.liamMail = true;
  vacu.defaultCAA = true;
  A = tripA;
  subdomains = {
    _acme-challenge.CNAME = [ "83895c55-d556-40c5-b41b-d55a312d99f9.auwwth.dis8.net." ];
    www.A = tripA;
  };
}
