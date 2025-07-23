{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ../tf2
    ./apex.nix
    ./android.nix
    ./thunderbolt.nix
    ./fwupd.nix
    ./zfs.nix
    ./virtualbox.nix
    ./sops.nix
    ./radicle.nix
    ./tpm-fido.nix
    ./podman.nix
    ./waydroid.nix
  ];

  boot.supportedFilesystems = [ "bcachefs" ];

  vacu.hostName = "fw";
  vacu.shell.color = "magenta";
  vacu.verifySystem.expectedMac = "e8:65:38:52:5c:59";
  vacu.systemKind = "laptop";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # currently back to normal kernel because waydroid requires it
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_15;
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;
  networking.networkmanager.enable = true;
  services.irqbalance.enable = true;
  # boot.kernelParams = [ "nvme.noacpi=1" ]; # DONT DO IT: breaks shit even more

  services.fprintd.enable = false; # kinda broken

  users.users.shelvacu.extraGroups = [ "dialout" ];

  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];

  vacu.packages = ''
    android-studio
    framework-tool
    fw-ectool
    headsetcontrol
    openterface-qt
    intiface-central
    osu-lazer
  '';

  services.power-profiles-daemon.enable = true;

  networking.firewall.enable = false;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.printing.enable = true;
  programs.system-config-printer.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.memtest86.enable = true;

  boot.loader.grub.mirroredBoots = [
    {
      devices = [ "nodev" ];
      path = "/boot0";
    }
    {
      devices = [ "nodev" ];
      path = "/boot1";
    }
  ];

  networking.hostId = "c6e309d5";

  services.openssh.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment?
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  #boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  #boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "fw/root";
    fsType = "zfs";
  };

  fileSystems."/cache" = {
    device = "fw/cache";
    fsType = "zfs";
  };

  fileSystems."/home/shelvacu/cache" = {
    device = "/cache/shelvacu";
    options = [ "bind" ];
  };

  fileSystems."/boot0" = {
    device = "/dev/disk/by-label/BOOT0";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "nofail"
    ];
  };

  fileSystems."/boot1" = {
    device = "/dev/disk/by-label/BOOT1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "nofail"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    extraPackages = [
      pkgs.rocmPackages.clr.icd
      pkgs.amdvlk
    ];
  };
  programs.nix-ld.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.postgresql.enable = true; # for development
}
