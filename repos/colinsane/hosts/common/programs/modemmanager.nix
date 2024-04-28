{ config, lib, pkgs, ... }:
let
  cfg = config.sane.programs.modemmanager;
in
{
  sane.programs.modemmanager = {
    # mmcli needs /run/current-system/sw/share/dbus-1 files to function
    enableFor.system = lib.mkIf (builtins.any (en: en) (builtins.attrValues cfg.enableFor.user)) true;
  };

  systemd.services.ModemManager = lib.mkIf cfg.enabled {
    aliases = [ "dbus-org.freedesktop.ModemManager1.service" ];
    after = [ "polkit.service" ];
    requires = [ "polkit.service" ];
    wantedBy = [ "network.target" ];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.ModemManager1";
      # only if started with `--debug` does mmcli let us issue AT commands like
      # `mmcli --modem any --command=<AT_CMD>`
      ExecStart = "${cfg.package}/bin/ModemManager --debug";
      # --debug sets DEBUG level logging: so reset
      ExecStartPost = "${cfg.package}/bin/mmcli --set-logging=INFO";

      Restart = "on-abort";
      StandardError = "null";
      CapabilityBoundingSet = "CAP_SYS_ADMIN CAP_NET_ADMIN";
      ProtectSystem = true;
      ProtectHome = true;
      PrivateTmp = true;
      RestrictAddressFamilies = "AF_NETLINK AF_UNIX AF_QIPCRTR";
      NoNewPrivileges = true;
    };
  };

  # so that ModemManager can discover when the modem appears
  services.udev.packages = lib.mkIf cfg.enabled [ cfg.package ];
}
