{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.sane.services.dyn-dns;
  getIp = pkgs.writeShellScript "dyn-dns-query-wan" ''
    # preferred method and fallback
    # OPNsense router broadcasts its UPnP endpoint every 30s
    timeout 60 ${pkgs.sane-scripts.ip-check}/bin/sane-ip-check --json || \
      ${pkgs.sane-scripts.ip-check}/bin/sane-ip-check --json --no-upnp
  '';
in
{
  options = {
    sane.services.dyn-dns = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };

      ipPath = mkOption {
        default = "/var/lib/uninsane/wan.txt";
        type = types.str;
        description = "where to store the latest WAN IPv4 address";
      };

      upnpPath = mkOption {
        default = "/var/lib/uninsane/upnp.txt";
        type = types.str;
        description = ''
          where to store the address of the UPNP device (if any) that can be used to create port forwards.
        '';
      };

      ipCmd = mkOption {
        default = "${getIp}";
        type = types.path;
        description = "command to run to query the current WAN IP";
      };

      interval = mkOption {
        type = types.str;
        default = "10min";
        description = "systemd time string for how frequently to re-check the IP";
      };

      restartOnChange = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "list of systemd unit files to restart when the IP changes";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dyn-dns = {
      description = "update this host's record of its WAN IP";
      serviceConfig.Type = "oneshot";
      restartTriggers = [(builtins.toJSON cfg)];

      after = [ "network.target" ];
      wantedBy = cfg.restartOnChange;
      before = cfg.restartOnChange;

      script = let
        jq = "${pkgs.jq}/bin/jq";
        sed = "${pkgs.gnused}/bin/sed";
      in ''
        mkdir -p "$(dirname '${cfg.ipPath}')"
        mkdir -p "$(dirname '${cfg.upnpPath}')"
        newIpDetails=$(${cfg.ipCmd})
        newIp=$(echo "$newIpDetails" | ${jq} ".wan" | ${sed} 's/^"//' | ${sed} 's/"$//')
        newUpnp=$(echo "$newIpDetails" | ${jq} ".upnp" | ${sed} 's/^"//' | ${sed} 's/"$//')
        oldIp=$(cat '${cfg.ipPath}' || true)
        oldUpnp=$(cat '${cfg.upnpPath}' || true)

        # systemd path units are triggered on any file write action,
        # regardless of content change. so only update the file if our IP *actually* changed
        if [ "$newIp" != "$oldIp" -a -n "$newIp" ]
        then
          echo "$newIp" > '${cfg.ipPath}'
          echo "WAN ip changed $oldIp -> $newIp"
        fi

        if [ "$newUpnp" != "$oldUpnp" -a -n "$newUpnp" ]
        then
          echo "$newUpnp" > '${cfg.upnpPath}'
          echo "UPNP changed $oldUpnp -> $newUpnp"
        fi

        exit $(test -f '${cfg.ipPath}' -a '${cfg.upnpPath}')
      '';
    };

    systemd.timers.dyn-dns = {
      # if anything wants dyn-dns.service, they surely want the timer too.
      wantedBy = [ "dyn-dns.service" ];
      timerConfig = {
        OnUnitActiveSec = cfg.interval;
      };
    };

    systemd.paths.dyn-dns-watcher = {
      before = [ "dyn-dns.timer" ];
      wantedBy = [ "dyn-dns.timer" ];
      pathConfig = {
        Unit = "dyn-dns-reactor.service";
        PathChanged = [ cfg.ipPath ];
      };
    };

    systemd.services.dyn-dns-reactor = {
      description = "react to the system's WAN IP changing";
      serviceConfig.Type = "oneshot";
      script = if cfg.restartOnChange != [] then ''
        ${pkgs.systemd}/bin/systemctl restart ${toString cfg.restartOnChange}
      '' else "${pkgs.coreutils}/bin/true";
    };
  };
}
