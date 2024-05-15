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

  systemd.services.NetworkManager-wait-online = lib.mkIf cfg.enabled {
    wantedBy = [ "network-online.target" ];
  };

  systemd.services.NetworkManager-dispatcher = lib.mkIf cfg.enabled {
    wantedBy = [ "NetworkManager.service" ];
    # to debug, add NM_DISPATCHER_DEBUG_LOG=1
    serviceConfig.ExecStart = [
      ""  # first blank line is to clear the upstream `ExecStart` field.
      "${cfg.package}/libexec/nm-dispatcher --persist"  # --persist is needed for it to actually run as a daemon
    ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = "1s";
  };

  environment.etc = lib.mkIf cfg.enabled {
    "NetworkManager/system-connections".source = "/var/lib/NetworkManager/system-connections";
    "NetworkManager/NetworkManager.conf".text = ''
      [device]
      # wifi.backend: wpa_supplicant or iwd
      wifi.backend=wpa_supplicant
      wifi.scan-rand-mac-address=true

      [logging]
      audit=false
      # level: TRACE, DEBUG, INFO, WARN, ERR, OFF
      level=INFO
      # domain=...

      [main]
      # dhcp:
      # - `internal` (default)
      # - `dhclient` (requires dhclient to be installed)
      # - `dhcpcd`   (requires dhcpcd to be installed)
      dhcp=internal
      # dns:
      # - `default`: update /etc/resolv.conf with nameservers provided by the active connection
      # - `none`: NM won't update /etc/resolv.conf
      # - `systemd-resolved`: push DNS config to systemd-resolved
      # - `dnsmasq`: run a local caching nameserver
      dns=none
      plugins=keyfile
      # rc-manager: how NM should write to /etc/resolv.conf
      # - may also write /var/lib/NetworkManager/resolv.conf
      rc-manager=unmanaged
      # systemd-resolved: send DNS config to systemd-resolved?
      systemd-resolved=false
      # debug=...  (see also: NM_DEBUG env var)
    '';
  };
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
