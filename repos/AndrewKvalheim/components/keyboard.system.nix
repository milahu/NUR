{ config, lib, ... }:

let
  inherit (builtins) readFile replaceStrings;

  identity = import ../library/identity.lib.nix { inherit lib; };
in
{
  console.useXkbConfig = true;
  services.xserver.xkb.layout = "halmakish";
  services.xserver.xkb.extraLayouts.halmakish = {
    description = "Halmakish";
    languages = [ "eng" ];
    symbolsFile = ./assets/halmakish.xkb;
  };

  services.kmonad = {
    enable = true;
    keyboards.default = {
      config = replaceStrings [ "░" ] [ "_" ] (readFile (config.host.dir + "/assets/halmakish.kbd"));
      defcfg = {
        enable = true;
        allowCommands = false;
        fallthrough = true;
      };
    };
  };
  systemd.services.kmonad-default.restartIfChanged = false;

  programs.ydotool.enable = true;

  # Permissions
  users.users.${identity.username}.extraGroups = [ "ydotool" ];
}
