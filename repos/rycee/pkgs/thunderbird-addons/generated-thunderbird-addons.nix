{ buildMozillaXpiAddon, fetchurl, lib, stdenv }:
  {
    "send-later" = buildMozillaXpiAddon {
      pname = "send-later";
      version = "10.7.8";
      addonId = "sendlater3@kamens.us";
      url = "https://addons.thunderbird.net/thunderbird/downloads/file/1042516/send_later-10.7.8-tb.xpi?src=";
      sha256 = "c6290ebbc8a22431d9cd59d12a62835dbd0df749bba6ff162c07b4e84fc503f0";
      meta = with lib;
      {
        homepage = "https://extended-thunder.github.io/send-later/";
        description = "True \"Send Later\" functionality to schedule the time for sending an email.";
        license = licenses.mpl20;
        mozPermissions = [
          "accountsFolders"
          "accountsRead"
          "activeTab"
          "addressBooks"
          "alarms"
          "compose"
          "compose.save"
          "compose.send"
          "menus"
          "messagesDelete"
          "messagesImport"
          "messagesMove"
          "messagesRead"
          "messagesUpdate"
          "notifications"
          "storage"
          "tabs"
        ];
        platforms = platforms.all;
      };
    };
    "tbkeys-lite" = buildMozillaXpiAddon {
      pname = "tbkeys-lite";
      version = "2.4.3";
      addonId = "tbkeys-lite@addons.thunderbird.net";
      url = "https://addons.thunderbird.net/thunderbird/downloads/file/1044591/tbkeys_lite-2.4.3-tb.xpi?src=";
      sha256 = "42cdfeae8e4e83725a4442881c0f00ff4759aa03dcd7d71d55a200058e2a1650";
      meta = with lib;
      {
        description = "Custom Thunderbird keybindings\n\nThis add-on is a follow on to Keyconfig which is no longer supported.\n\nIt is aimed at power users. Please look at the GitHub site before leaving a one star review about documentation or usability.";
        license = licenses.mpl20;
        mozPermissions = [ "storage" ];
        platforms = platforms.all;
      };
    };
  }