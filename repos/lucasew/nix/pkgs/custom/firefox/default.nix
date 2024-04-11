{
  nbr,
  lib,
  wrapFirefox,
  firefox-esr-102-unwrapped,
  fetchFirefoxAddon,
  firefox-bin,
  callPackage,
}:
wrapFirefox firefox-esr-102-unwrapped {
  desktopName = "Firefox (wrapped)";
  applicationName = "firefox";
  nixExtensions =
    (with nbr.firefoxExtensions; [
      darkreader
      facebook-container
      languagetool
      i-dont-care-about-cookies
      sponsorblock
      tampermonkey
      ublock-origin
      tweak-new-twitter
      floccus
      video-downloadhelper
    ])
    ++ ([ (callPackage ./base16-ext { }) ]);
  extraPolicies = {
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
  };
}
