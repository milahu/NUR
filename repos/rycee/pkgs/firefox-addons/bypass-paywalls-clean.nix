{
  buildFirefoxXpiAddon,
  lib,
  ...
}:

buildFirefoxXpiAddon {
  pname = "bypass-paywalls-clean";
  version = "4.2.9.6";
  addonId = "magnolia@12.34";
  url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-4.2.9.6.xpi&branch=main";
  sha256 = "25ff70623155c447c0197a3ba8c146dbc816e298a9bcdb8e02fa89197281ab8b";
  meta = with lib; {
    homepage = "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean";
    description = "Bypass Paywalls of (custom) news sites";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
