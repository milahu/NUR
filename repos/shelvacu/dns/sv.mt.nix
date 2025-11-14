{ lib, config, ... }:
let
  inherit (lib) singleton;
  inherit (config.vacu) dnsData;
in
{
  vacu.dns."sv.mt" =
    { ... }:
    {
      vacu.liamMail = true;
      vacu.defaultCAA = true;
      A = singleton dnsData.propPublicV4;
      subdomains = {
        "2e14".A = singleton dnsData.propPublicV4;
        "clientauth.2e14".A = singleton dnsData.propPublicV4;

        "jf".A = singleton dnsData.propPublicV4;
        "f".A = singleton dnsData.propPublicV4;
        "files".A = singleton dnsData.propPublicV4;
        "copy".A = singleton dnsData.propPublicV4;
        "copyparty".A = singleton dnsData.propPublicV4;
        thisthirdlevelisownedbyshelandwasnotmadeavailabletoemily.NS = [
          "thisns1isonlyusedbyshelandisnotusedforthirdlevelregistrationfor.emilygeil.com."
          "thisns2isonlyusedbyshelandisnotusedforthirdlevelregistrationfor.emilygeil.com."
          "thisns3isonlyusedbyshelandisnotusedforthirdlevelregistrationfor.emilygeil.com."
          "thisns4isonlyusedbyshelandisnotusedforthirdlevelregistrationfor.emilygeil.com."
          "thisns5isonlyusedbyshelandisnotusedforthirdlevelregistrationfor.emilygeil.com."
        ];
        www.A = singleton dnsData.propPublicV4;
      };
    };
}
