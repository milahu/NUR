# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/B364-8AA4";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/7b93bdc2-7fa7-4422-893b-e0e293010350";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    {
      device = "/dev/disk/by-uuid/7b93bdc2-7fa7-4422-893b-e0e293010350";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/7b93bdc2-7fa7-4422-893b-e0e293010350";
      fsType = "btrfs";
      options = [ "subvol=@persist" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/7b93bdc2-7fa7-4422-893b-e0e293010350";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/0cf9c2a0-5981-4759-8709-43c87e8a1b92"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}