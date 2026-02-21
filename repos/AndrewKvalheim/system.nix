{ lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) float int path submodule;
in
{
  imports = [
    ./components/applications.system.nix
    ./components/apt-cache.system.nix
    ./components/backup.system.nix
    ./components/boot.system.nix
    ./components/desktop.system.nix
    ./components/firmware.system.nix
    ./components/keyboard.system.nix
    ./components/locale.system.nix
    ./components/logs.system.nix
    ./components/mail.system.nix
    ./components/networking.system.nix
    ./components/nix.system.nix
    ./components/openpgp.system.nix
    ./components/policy.system.nix
    ./components/power.system.nix
    ./components/printer.system.nix
    ./components/scanner.system.nix
    ./components/ssh.system.nix
    ./components/storage.system.nix
    ./components/syncthing.system.nix
    ./components/tor.system.nix
    ./components/u2f.system.nix
    ./components/updates.system.nix
    ./components/users.system.nix
    ./components/virtualization.system.nix
    ./components/wireguard.system.nix
  ];

  options = {
    host = {
      cpu_cores = mkOption { type = int; };
      cpu_mark = mkOption {
        type = submodule {
          options = {
            multi = mkOption { type = int; };
            single = mkOption { type = int; };
          };
        };
      };
      dir = mkOption { type = path; };
      display_density = mkOption { type = float; };
      display_width = mkOption { type = int; };
      ram_gb = mkOption { type = int; };
    };
  };
}
