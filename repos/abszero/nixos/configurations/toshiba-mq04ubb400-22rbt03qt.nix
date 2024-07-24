{ inputs, lib, ... }:

let
  inherit (builtins) fromJSON readFile;
  inherit (lib) recursiveUpdate;

  proxySettings = fromJSON (readFile ./fracture-ray/proxy.json);

  mainModule = {
    abszero = {
      profiles.full.enable = true;

      zramSwap.enable = true;

      users.admins = [ "weathercold" ];

      hardware.inspiron-7405.enable = true;

      wayland.windowManager.hyprland.enable = true;

      services = {
        displayManager.tuigreet.enable = true;
        xray = recursiveUpdate proxySettings {
          enable = true;
          preset = "vless-tcp-xtls-reality-client";
          reality.shortId = "77b852c767077a1a";
        };
      };

      themes.catppuccin.enable = true;
    };

    # BIOS-compatible GPT layout
    disko.devices.disk.toshiba-mq04ubb400-22rbt03qt = {
      type = "disk";
      device = "/dev/disk/by-id/ata-TOSHIBA_MQ04UBB400_22RBT03QT";
      content = {
        type = "gpt";
        partitions = {
          bios = {
            label = "toshiba-mq04ubb400-22rbt03qt-bios";
            size = "1M";
            type = "EF02"; # BIOS boot partition
            priority = 0;
          };
          esp = {
            label = "toshiba-mq04ubb400-22rbt03qt-esp";
            size = "512M";
            type = "EF00"; # EFI system partition
            priority = 1;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "noatime"
                "noauto"
                "nodev" # block device files for security
                "nofail"
                "nosuid" # block suid and sgid bits for security
                "x-systemd.automount"
                "x-systemd.idle-timeout=10min"
              ];
            };
          };
          data = {
            label = "toshiba-mq04ubb400-22rbt03qt-data";
            size = "2T";
            priority = 2;
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountpoint = "/home";
              mountOptions = [
                "noatime"
                "nodev"
                "nosuid"
              ];
            };
          };
          nixos = {
            label = "toshiba-mq04ubb400-22rbt03qt-nixos";
            end = "-16G";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountpoint = "/";
              mountOptions = [ "noatime" ];
            };
          };
          swap = {
            label = "toshiba-mq04ubb400-22rbt03qt-swap";
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "pages";
              resumeDevice = true;
            };
          };
        };
      };
    };

    catppuccin.accent = "pink";

    users.users = rec {
      weathercold = {
        description = "Weathercold";
        isNormalUser = true;
        hashedPassword = "$6$QOTimFq0v8u6oN.I$.m0BQc/tC6/8nluwwQT7AmkbJbfNoh2PnO9biVL4wgWA22zlb/0HheieexWgISAB67r/7floX3bQpZrUjZv9v.";
      };
      root = {
        inherit (weathercold) hashedPassword;
      };
    };

    documentation.enable = false; # Speed up builds
  };
in

{
  imports = [ ./_options.nix ];

  nixosConfigurations.toshiba-mq04ubb400-22rbt03qt = {
    system = "x86_64-linux";
    modules = [
      inputs.nixos-hardware.nixosModules.dell-inspiron-7405
      mainModule
    ];
  };
}
