{
  buildMozillaXpiAddon,
  lib,
  ...
}:

buildMozillaXpiAddon {
  pname = "tbkeys";
  version = "2.4.1";
  addonId = "tbkeys@addons.thunderbird.net";
  url = "https://github.com/wshanks/tbkeys/releases/download/v2.4.1/tbkeys.xpi";
  sha256 = "83b61414bc0c7ed465e135254c51f81aafbfa2b6513d6de44e07146057d13fb6";
  meta = with lib; {
    homepage = "https://github.com/wshanks/tbkeys";
    description = "Custom keyboard shortcuts for Thunderbird";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
