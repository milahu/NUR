{ config, lib, ... }:
let
  cfg = config.sane.programs.wpa_supplicant;
in
{
  sane.programs.wpa_supplicant = {};
  services.udev.packages = lib.mkIf cfg.enabled [ cfg.package ];
  # need to be on systemd.packages so we get its service file
  systemd.packages = lib.mkIf cfg.enabled [ cfg.package ];
}
