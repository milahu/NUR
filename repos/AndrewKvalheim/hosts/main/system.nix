{ lib, pkgs, ... }:

let
  inherit (lib) getExe' throwIf versionAtLeast;

  identity = import ../../common/resources/identity.nix;
in
{
  imports = [
    ../../common/system.nix
    <nixos-hardware/lenovo/thinkpad/p16s/amd/gen2>
    /etc/nixos/hardware-configuration.nix
    ./local/system.nix
  ];

  # Host parameters
  host = {
    name = "main";
    local = ./local;
    resources = ./resources;
  };

  # Workaround for drm/amd#3925, drm/amd#4141
  boot.kernelPackages = throwIf (versionAtLeast pkgs.linux.version "6.16") "Kernel no longer requires override" pkgs.linuxPackages_6_16;

  # Hardware
  systemd.services.configure-sound-leds = rec {
    wantedBy = [ "sound.target" ];
    after = wantedBy;
    serviceConfig.Type = "oneshot";
    script = ''
      echo follow-route > /sys/class/sound/ctl-led/mic/mode
      echo off > /sys/class/sound/ctl-led/speaker/mode # follow-route pending https://discourse.nixos.org/t/20480
    '';
  };

  # Keyboard
  services.udev.extraHwdb = ''
    # From:
    #   角 ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░
    #    ↹  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░
    #     ░  ░  ░  ░  ░  g  ░  ░  ░  ░  ░  ░  ░  ░
    #      ⇧  ░  ░  ░  ░  ░  ░  m  ░  ░  ░  ░  ░
    #      ⎈  ❖  ⎇  無    ␣  換 仮 ⇮  ⎙  ░
    # To:
    #   ⎙  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░
    #    g  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░  ░
    #     ░  ░  ░  ░  ░  ↵  ░  ░  ░  ░  ░  ░  ░  ░
    #      m  ░  ░  ░  ░  ░  ░  ␣  ░  ░  ░  ░  ░
    #      ❖  ⎇  ⎈  ↹     ⇧  ⇧  ⇮  ⎇  ❖  ░
    evdev:name:AT Translated Set 2 keyboard:*
      KEYBOARD_KEY_29=sysrq
      KEYBOARD_KEY_0f=g
      KEYBOARD_KEY_22=enter
      KEYBOARD_KEY_2a=m
      KEYBOARD_KEY_32=space
      KEYBOARD_KEY_1d=leftmeta
      KEYBOARD_KEY_db=leftalt
      KEYBOARD_KEY_38=leftctrl
      KEYBOARD_KEY_7b=tab
      KEYBOARD_KEY_39=leftshift
      KEYBOARD_KEY_79=rightshift
      KEYBOARD_KEY_70=rightalt
      KEYBOARD_KEY_b8=leftalt
      KEYBOARD_KEY_b7=rightmeta
  '';
  services.kmonad.keyboards.default.device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  # Nix
  system.stateVersion = "22.05"; # Permanent

  # Filesystems
  # TODO: Set `chattr +i` on intermittent mount points
  fileSystems = let base = { fsType = "nfs"; options = [ "noauto" "user" ]; }; in {
    "/home/ak/annex" = base // { device = "closet.home.arpa:/mnt/hdd/home-ak-annex"; };
    "/home/ak/services-hdd" = base // { device = "closet.home.arpa:/mnt/hdd/services"; };
    "/home/ak/services-ssd" = base // { device = "closet.home.arpa:/mnt/ssd/services"; };
  };
  security.wrappers = with pkgs; {
    # Workaround for NixOS/nixpkgs#24913, NixOS/nixpkgs#9848
    "mount.nfs" = { source = getExe' nfs-utils "mount.nfs"; owner = "root"; group = "root"; setuid = true; };
    "umount.nfs" = { source = getExe' nfs-utils "umount.nfs"; owner = "root"; group = "root"; setuid = true; };
  };
  systemd.automounts = map
    (path: {
      wantedBy = [ "remote-fs.target" ];
      automountConfig.TimeoutIdleSec = 30;
      where = path;
    }) [
    "/home/ak/annex"
    "/home/ak/services-hdd"
    "/home/ak/services-ssd"
  ];

  # Mouse
  services.input-remapper.enable = true;

  # Networking
  systemd.network.links = {
    "10-dock".linkConfig.Name = "dock";
    "10-jack".linkConfig.Name = "jack";
    "10-wifi".linkConfig.Name = "wifi";
  };

  # usbmuxd
  services.usbmuxd.enable = true;

  # Wireshark
  programs.wireshark.enable = true;
  users.users.${identity.username}.extraGroups = [ "usbmux" "wireshark" ];

  # Devices
  services.udev.packages = with pkgs; [ espressif-serial ];

  # LLM
  nixpkgs.config.rocmSupport = true;
  services.ollama = { enable = true; rocmOverrideGfx = "11.0.2"; /* Pending support for gfx1103 */ };
  systemd.services.ollama.serviceConfig.Nice = 5;
}
