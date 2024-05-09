# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/21adb950-9d20-417f-8011-34c65ad33a65";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/9520-0592";
      fsType = "vfat";
    };

  fileSystems."/data" =
    {
      device = "dpool/data";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "hpool/users";
      fsType = "zfs";
    };

  fileSystems."/home/bjorn" =
    {
      device = "hpool/users/bjorn";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    {
      device = "rpool/system/persist";
      fsType = "zfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/51c8dd7d-bd2c-4af6-95dc-54ef4b75c152"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
