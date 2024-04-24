# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "rpool/nixos";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };
    "/var" = {
      device = "rpool/nixos/var";
      fsType = "zfs";
    };
    "/etc" = {
      device = "rpool/nixos/etc";
      fsType = "zfs";
    };
    "/var/lib" = {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
    };
    "/var/spool" = {
      device = "rpool/nixos/var/spool";
      fsType = "zfs";
    };
    "/var/log" = {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
    };
    "/root" = {
      device = "rpool/userdata/home/root";
      fsType = "zfs";
    };
    "/home" = {
      device = "rpool/userdata/home";
      fsType = "zfs";
    };
    "/home/noobuser" = {
      device = "rpool/userdata/home/noobuser";
      fsType = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/34DE-1CD3";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}