{ config, lib, pkgs, ... }:
let
  cfg = config.sane.services.rsync-net;
  sane-backup-rsync-net = pkgs.static-nix-shell.mkBash {
    pname = "sane-backup-rsync-net";
    pkgs = [
      "nettools"
      "openssh"
      "rsync"
      "sane-scripts.vpn"
      "sanebox"
    ];
    srcRoot = ./.;
  };
in
{
  options = with lib; {
    sane.services.rsync-net.enable = mkOption {
      default = false;
      type = types.bool;
    };
    sane.services.rsync-net.dirs = mkOption {
      type = types.listOf types.str;
      description = ''
        list of directories to upload to rsync.net.
        note that this module does NOT add any encryption to the files (layer that yourself).
      '';
      default = [
        "/nix/persist/private"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.rsync-net = {
      description = "backup files to rsync.net";
      serviceConfig.ExecStart = "${lib.getExe sane-backup-rsync-net} ${lib.escapeShellArgs cfg.dirs}";
      serviceConfig.Type = "simple";
      serviceConfig.Restart = "no";
      serviceConfig.User = "colin";

      serviceConfig.AmbientCapabilities = [
        # needs to be able to read files owned by any user
        "CAP_DAC_READ_SEARCH"
      ];
      serviceConfig.RestrictNetworkInterfaces = [
        # strictly forbid sending traffic over any non ethernet/wifi interface,
        # because i don't want this e.g. consuming all my cellular data.
        # TODO: test this. i don't know that the moby kernel/systemd actually supports these options
        "lo"  # for DNS
        "eth0"
        "wlan0"
      ];

      # hardening
      serviceConfig.CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" ];
      serviceConfig.ReadWritePaths = builtins.map (d: "${d}/zzz-rsync-net") cfg.dirs;
      serviceConfig.ReadOnlyPaths = "/nix/persist/private";
      serviceConfig.RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";

      serviceConfig.LockPersonality = true;
      serviceConfig.MemoryDenyWriteExecute = true;
      serviceConfig.PrivateMounts = true;
      serviceConfig.PrivateUsers = true;
      serviceConfig.ProcSubset = "pid";
      serviceConfig.ProtectClock = "true";
      serviceConfig.ProtectControlGroups = true;
      serviceConfig.ProtectHome = true;
      serviceConfig.ProtectHostname = true;
      serviceConfig.ProtectKernelLogs = true;
      serviceConfig.ProtectKernelModules = true;
      serviceConfig.ProtectKernelTunables = true;
      serviceConfig.ProtectProc = "invisible";
      serviceConfig.ProtectSystem = "strict";
      serviceConfig.RemoveIPC = true;
      serviceConfig.RestrictSUIDSGID = true;
      serviceConfig.SystemCallArchitectures = "native";
      serviceConfig.SystemCallFilter = "@system-service @mount";
      # hardening exceptions:
      serviceConfig.NoNewPrivileges = false;  #< bwrap'd dac_read_search
      serviceConfig.PrivateDevices = false;  #< passt/pasta
      serviceConfig.RestrictNamespaces = false;  #< bwrap
    };
    systemd.timers.rsync-net = {
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        # run 2x daily; at 11:00:00, 23:00:00
        OnCalendar = "11,23:00:00";
      };
    };
  };
}
