# clightning: Bitcoin Lightning Network daemon
#
# module is based on nix-bitcoin: <https://github.com/fort-nix/nix-bitcoin/blob/master/modules/clightning.nix>
#
# reasons to prefer this module over nix-bitcoin's include:
# - compatible with nixpkgs' bitcoind service
# - more self-contained
#   - doesn't pull in an entire nix secrets management implementation
#     although that can be disabled with `nix-bitcoin.secretsSetupMethod = "manual"`
#
{ config, lib, pkgs, ... }:

let
  cfg = config.sane.services.clightning;
  bitcoind = config.services.bitcoind."${cfg.bitcoindName}";
  # clightning config docs: <https://github.com/ElementsProject/lightning/blob/master/doc/lightningd-config.5.md>
  configFile = pkgs.writeText "config" ''
    network=bitcoin
    bitcoin-datadir=${bitcoind.dataDir}
    ${lib.optionalString (cfg.proxy != null) "proxy=${cfg.proxy}"}
    ${lib.optionalString (cfg.publicAddress != null) "addr=${cfg.publicAddress}"}
    always-use-proxy=${lib.boolToString cfg.always-use-proxy}
    bind-addr=${cfg.address}:${toString cfg.port}
    bitcoin-rpcconnect=127.0.0.1
    bitcoin-rpcport=8332
    bitcoin-rpcuser=${cfg.user}
    rpc-file-mode=0660
    log-timestamps=false
    ${cfg.extraConfig}
  '';
in
{
  options = with lib; {
    sane.services.clightning = {
      enable = mkEnableOption "clightning, a Lightning Network implementation in C";
      package = mkPackageOption pkgs "clightning" { };
      bitcoindName = mkOption {
        type = types.str;
        default = "mainnet";
        description = ''
          name of bitcoind config to attach to.
          for example if you configured `services.bitcoind.mainnet`, then specify "mainnet" here.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "clightning";
        description = mdDoc "The user as which to run clightning.";
      };
      group = mkOption {
        type = types.str;
        default = cfg.user;
        description = mdDoc "The group as which to run clightning.";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/clightning";
        description = mdDoc "The data directory for clightning.";
      };
      networkDir = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/bitcoin";
        description = mdDoc "The network data directory.";
      };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = mdDoc "Address to listen for peer connections.";
      };
      publicAddress = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          address to publish to peers.
          leaving this empty will prevent incoming connections and channels, but it should still be possible to create outgoing channels.

          formats:
          - statictor:<ip>:<port>
            creates a tor hidden service based on this node's pubkey, which remains constant across reboots.
        '';
        example = "statictor:127.0.0.1:9051";
      };
      getPublicAddressCmd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc ''
          Bash expression which outputs the public service address to announce to peers.
          this is an alternative to the `publicAddress` option, for if the address is not known statically (e.g. tor).
        '';
      };

      port = mkOption {
        type = types.port;
        default = 9735;
        description = mdDoc "Port to listen for peer connections.";
      };
      proxy = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc ''
          Socks proxy for connecting to Tor nodes (or for all connections if option always-use-proxy is set).
        '';
      };
      always-use-proxy = mkOption {
        type = types.bool;
        default = cfg.proxy != null;
        description = mdDoc ''
          Always use the proxy, even to connect to normal IP addresses.
          You can still connect to Unix domain sockets manually.
          This also disables all DNS lookups, to avoid leaking address information.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          alias=mynode
        '';
        description = mdDoc ''
          Extra lines appended to the configuration file.

          See all available options at
          https://github.com/ElementsProject/lightning/blob/master/doc/lightningd-config.5.md
          or by running {command}`lightningd --help`.
        '';
      };
      extraConfigFiles = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          extra files to populate the config from at runtime.
          useful if you need to pass config you wish to keep outside the nix store, such as secrets.

          you should probably populate this with a file that defines
          bitcoin-rpcpassword=MY_HASHED_RPCAUTH_PASSWORD
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.clightning = {
      path  = [ bitcoind.package ];
      # note the wantedBy bitcoind: this should make it so that a bitcoind restart causes clightning to also restart (instead of to only stop)
      wantedBy = [ "bitcoind-${cfg.bitcoindName}.service" "multi-user.target" ];
      requires = [ "bitcoind-${cfg.bitcoindName}.service" ];
      after = [ "bitcoind-${cfg.bitcoindName}.service" ];

      serviceConfig = {
        # TODO: hardening
        ExecStart = "${cfg.package}/bin/lightningd --lightning-dir=${cfg.dataDir}";
        User = cfg.user;
        Restart = "on-failure";
        RestartSec = "30s";

        ReadWritePaths = [ cfg.dataDir ];

        # hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
      };

      preStart = ''
        # Remove an existing socket so that `postStart` can detect when a new
        # socket has been created and clightning is ready to accept RPC connections.
        # This will no longer be needed when clightning supports systemd startup notifications.
        rm -f ${cfg.networkDir}/lightning-rpc

        umask u=rw,g=r,o=
        {
          cat ${configFile} ${lib.concatStringsSep " " cfg.extraConfigFiles}
          ${lib.optionalString (cfg.getPublicAddressCmd != null) ''
            echo "announce-addr=$(${cfg.getPublicAddressCmd}):${builtins.toString cfg.port}"
          ''}
        } > ${cfg.dataDir}/config
      '';
      # Wait until the rpc socket appears
      postStart = ''
        while [[ ! -e ${cfg.networkDir}/lightning-rpc ]]; do
            sleep 0.1
        done
        # Needed to enable lightning-cli for users with group 'clightning'
        chmod g+rx ${cfg.networkDir}
      '';
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      extraGroups = [ "bitcoind-${cfg.bitcoindName}" ];
      home = cfg.dataDir;
    };
    users.groups.${cfg.group} = {};

    sane.fs."${cfg.dataDir}".dir.acl = {
      user = cfg.user;
      group = cfg.group;
      # must be traversable by group, for `lightning-cli` to be usable by group members.
      mode = "0710";
    };

    # ~/.lightning is needed only when interactively calling `lightning-cli` as the `clightning` user.
    sane.fs."${cfg.dataDir}/.lightning" = {
      symlink.target = cfg.dataDir;
      wantedBeforeBy = [ "clightning.service" ];
    };
  };
}
