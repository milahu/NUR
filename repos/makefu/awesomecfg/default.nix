{ pkgs
, lib
, alsaUtils
, xbacklight
, networkmanagerapplet
, blueman
, clipit
, flameshot
, modkey ? "Mod4"
, locker? "${pkgs.xlock}/bin/xlock -mode blank"
, ... }:

{
  # replace: @alsaUtils@ @xlockmore@ @xbacklight@ @modkey@
  full = lib.makeOverridable pkgs.substituteAll {
    name = "awesome_full_config";
    inherit alsaUtils locker xbacklight modkey networkmanagerapplet blueman clipit flameshot ;
    isExecutable = false;
    src = ./full.cfg;
  };

  kiosk = lib.makeOverridable pkgs.substituteAll {
    name = "awesome_kiosk_config";
    inherit alsaUtils locker xbacklight modkey;
    isExecutable = false;
    src = ./kiosk.lua;
  };
}
