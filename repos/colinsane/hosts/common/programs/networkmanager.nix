# Network Manager:
# i manage this myself because the nixos service is not flexible enough.
# - it unconditionally puts modemmanager onto the system path, preventing me from patching modemmanager's service file (without an overlay).
#
# XXX: it's normal to see error messages on an ethernet-only host, even when using nixos' official networkmanager service:
# - `Couldn't initialize supplicant interface: Failed to D-Bus activate wpa_supplicant service`
{ config, lib, pkgs, ... }:
let
  cfg = config.sane.programs.networkmanager;
in
{
  sane.programs.networkmanager = {
    suggestedPrograms = [ "wpa_supplicant" ];
    enableFor.system = lib.mkIf (builtins.any (en: en) (builtins.attrValues cfg.enableFor.user)) true;
  };

  # add to systemd.packages so we get the service file it ships, then override what we need to customize (taken from nixpkgs)
  systemd.packages = lib.mkIf cfg.enabled [ cfg.package ];
  systemd.services.NetworkManager = lib.mkIf cfg.enabled {
    wantedBy = [ "network.target" ];
    aliases = [ "dbus-org.freedesktop.NetworkManager.service" ];

    serviceConfig = {
      StateDirectory = "NetworkManager";
      StateDirectoryMode = 755; # not sure if this really needs to be 755
    };
  };

  systemd.services.NetworkManager-wait-online = lib.mkIf cfg.enabled{
    wantedBy = [ "network-online.target" ];
  };

  environment.etc."NetworkManager/NetworkManager.conf".text = lib.mkIf cfg.enabled ''
    # TODO: much of this is likely not needed.
    [connection]
    ethernet.cloned-mac-address=preserve
    wifi.cloned-mac-address=preserve
    wifi.powersave=null

    [device]
    wifi.backend=wpa_supplicant
    wifi.scan-rand-mac-address=true

    [keyfile]
    # keyfile.path: where to check for connection credentials
    path=/var/lib/NetworkManager/system-connections
    unmanaged-devices=null

    [logging]
    audit=false
    level=WARN

    [main]
    dhcp=internal
    dns=systemd-resolved
    plugins=keyfile
    rc-manager=unmanaged
  '';
  hardware.wirelessRegulatoryDatabase = lib.mkIf cfg.enabled true;
  networking.useDHCP = lib.mkIf cfg.enabled false;
  users.groups = lib.mkIf cfg.enabled {
    networkmanager.gid = config.ids.gids.networkmanager;
  };
  services.udev.packages = lib.mkIf cfg.enabled [ cfg.package ];
  security.polkit.enable = lib.mkIf cfg.enabled true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("networkmanager")
        && (action.id.indexOf("org.freedesktop.NetworkManager.") == 0
            || action.id.indexOf("org.freedesktop.ModemManager")  == 0
        ))
          { return polkit.Result.YES; }
    });
  '';

  boot.kernelModules = [ "ctr" ];  #< TODO: needed (what even is this)?
  # TODO: polkit?
  # TODO: NetworkManager-ensure-profiles?
}
