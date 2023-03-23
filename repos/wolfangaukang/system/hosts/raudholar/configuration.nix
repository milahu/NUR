{ config
, pkgs
, lib
, inputs
, ...

}:

let
  inherit (inputs) self;

in {
  imports = [
    #<nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    "${self}/system/profiles/console.nix"
  ];

  # FIXME: Still testing
  #virtualisation.qemu.options = [
  # # "-vga none"
  #  "-device virtio-gpu-pci"
  #];
  #---------------------

  # assertion: The ‘fileSystems’ option does not specify your root file system.
  fileSystems."/" = lib.mkDefault { device = "/dev/disk/by-label/nixos"; };
  # assertion: You must set the option ‘boot.loader.grub.devices’ or 'boot.loader.grub.mirroredBoots' to make the system bootable.
  boot.loader.grub.enable = lib.mkDefault false;

  environment.systemPackages = with pkgs; [
    vim
  ];
  services.cloudflare-warp.enable = true;
  #services.cloudflare-warp.logLevel = "INFO";
  #programs = {
  #  sway.enable = true;
  #  xwayland.enable = true;
  #};
  #services.xserver = {
  #  enable = false;
  #  logFile = "/tmp/xserver.log";
  #  layout = "us";
  #  xkbVariant = "colemak";
  #  #desktopManager.enlightenment.enable = true;
  #  #displayManager.ly = {
  #  #  enable = true;
  #  #  #defaultUser = "bjorn";
  #  #  extraConfig = ''
  #  #  lang = pt
  #  #  asterisk = u
  #  #  '';
  #  #};
  #};

  system.stateVersion = "20.09";
}
