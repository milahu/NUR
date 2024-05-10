{ config, lib, pkgs, ... }:
let
  cfg = config.sane.services.trust-dns;
  dns = config.sane.dns;
  toml = pkgs.formats.toml { };
  instanceModule = with lib; types.submodule {
    options = {
      port = mkOption {
        type = types.port;
        default = 53;
      };
      listenAddrs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          IP addresses to serve requests from.
        '';
      };
      substitutions = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          text substitutions to make on the config and zone file before starting trust-dns.
        '';
        example = {
          "%CNAMESELF%" = "lappy";
          "%AWAN%" = ''"$(cat /var/www/wan.txt)"'';
        };
      };
      extraConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };
  };
  mkSystemdService = flavor: { port, listenAddrs, substitutions, extraConfig }: let
    sed = "${pkgs.gnused}/bin/sed";
    zoneTemplate = pkgs.writeText
      "uninsane.org.zone.in"
      config.sane.dns.zones."uninsane.org".rendered;
    configTemplate = toml.generate "trust-dns-${flavor}.toml" (
      (
        lib.filterAttrsRecursive (_: v: v != null) config.services.trust-dns.settings
      ) // {
        listen_addrs_ipv4 = listenAddrs;
      } // extraConfig
    );
    configPath = "/var/lib/trust-dns/${flavor}-config.toml";
    sedArgs = lib.mapAttrsToList (key: value: ''-e "s/${key}/${value}/g"'') substitutions;
    subs = lib.concatStringsSep " " sedArgs;
  in {
    description = "trust-dns Domain Name Server (serving ${flavor})";
    unitConfig.Documentation = "https://trust-dns.org/";

    wantedBy = [ "default.target" ];

    preStart = lib.concatStringsSep "\n" (
      [''
        mkdir -p "/var/lib/trust-dns/${flavor}"
        ${sed} ${subs} -e "" "${configTemplate}" > "${configPath}"
      ''] ++ lib.mapAttrsToList (zone: { rendered, ... }: ''
        ${sed} ${subs} -e "" ${pkgs.writeText "${zone}.zone.in" rendered} \
          > "/var/lib/trust-dns/${flavor}/${zone}.zone"
      '') dns.zones
    );

    serviceConfig = config.systemd.services.trust-dns.serviceConfig // {
      ExecStart = lib.escapeShellArgs ([
        "${pkgs.trust-dns}/bin/${pkgs.trust-dns.meta.mainProgram}"
        "--port"     (builtins.toString port)
        "--zonedir"  "/var/lib/trust-dns/${flavor}"
        "--config"   "${configPath}"
      ] ++ lib.optionals config.services.trust-dns.debug [
        "--debug"
      ] ++ lib.optionals config.services.trust-dns.quiet [
        "--quiet"
      ]);
      ReadOnlyPaths = [ "/var/lib/uninsane" ];  # for dyn-dns (wan.txt)
    };
  };
in
{
  options = with lib; {
    sane.services.trust-dns = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
      instances = mkOption {
        default = {};
        type = types.attrsOf instanceModule;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # enable nixpkgs' trust-dns so that i get its config generation
    # but don't actually enable the systemd service... i'll instantiate *multiple* instances per interface further below
    services.trust-dns.enable = true;

    # don't bind to IPv6 until i explicitly test that stack
    services.trust-dns.settings.listen_addrs_ipv6 = [];
    services.trust-dns.quiet = true;
    # FIXME(2023/11/26): services.trust-dns.debug doesn't log requests: use RUST_LOG=debug env for that.
    # - see: <https://github.com/hickory-dns/hickory-dns/issues/2082>
    # services.trust-dns.debug = true;

    users.groups.trust-dns = {};
    users.users.trust-dns = {
      group = "trust-dns";
      isSystemUser = true;
    };

    systemd.services = lib.mkMerge [
      {
        trust-dns.enable = false;
        trust-dns.serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = "trust-dns";
          Group = "trust-dns";
          wantedBy = lib.mkForce [];
        };
      }
      (lib.mapAttrs'
        (flavor: instanceConfig: {
          name = "trust-dns-${flavor}";
          value = mkSystemdService flavor instanceConfig;
        })
        cfg.instances
      )
    ];
  };
}
