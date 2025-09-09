{ lib, pkgs, ... }:

let
  inherit (lib) escapeShellArg;
  inherit (import ../library/utilities.lib.nix { inherit lib; }) frame;

  identity = import ../library/identity.lib.nix;
  palette = import ../library/palette.lib.nix { inherit lib pkgs; };

  printContactInfo = with palette.ansiFormat; ''
    echo $'\n'${escapeShellArg (frame magenta ''
      ${magenta "If found, please contact:"}

        ${blue "Name:"} ${identity.name.long}
       ${blue "Email:"} ${identity.email}
       ${blue "Phone:"} ${identity.phone}
    '')}
  '';
in
{
  # Memory
  zramSwap.enable = true;

  # Disks
  services.smartd = {
    enable = true;
    notifications.mail.enable = true;
  };

  # LVM on LUKS
  boot.initrd.luks = {
    gpgSupport = true;
    devices.pv = {
      device = "/dev/disk/by-partlabel/pv-enc";
      allowDiscards = true;
      fallbackToPassword = true;
      gpgCard.encryptedPass = ./assets/luks-passphrase.local.gpg;
      gpgCard.publicKey = identity.openpgp.asc;
      preOpenCommands = printContactInfo;
    };
  };

  # /
  fileSystems."/".options = [ "compress=zstd:2" "discard=async" "noatime" ];
  services.btrfs.autoScrub.enable = true;
  security.sudo.allowedCommands = [ "/run/current-system/sw/bin/btrfs balance start --enqueue -dusage=50 -musage=50 /" ];

  # /boot
  fileSystems."/boot".options = [ "umask=0077" ];

  # /tmp
  boot.tmp.cleanOnBoot = true;
}
