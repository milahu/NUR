{ config, lib, pkgs, ... }:
let
  trust-dns-nmhook = pkgs.static-nix-shell.mkPython3Bin {
    pname = "trust-dns-nmhook";
    srcRoot = ./.;
  };
  cfg = config.sane.services.trust-dns;
  dns = config.sane.dns;
  toml = pkgs.formats.toml { };
  instanceModule = with lib; types.submodule ({ config, ...}: {
    options = {
      port = mkOption {
        type = types.port;
        default = 53;
      };
      listenAddrsIpv4 = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" ];
        description = ''
          IPv4 addresses to serve requests from.
        '';
      };
      listenAddrsIpv6 = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          IPv6 addresses to serve requests from.
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
      includes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          list of paths to cat into the final config.
          non-existent paths are skipped.
          supports shell-style globbing.
        '';
      };
      enableRecursiveResolver = mkOption {
        type = types.bool;
        default = false;
        description = ''
          act as a recursive resolver
        '';
      };
      extraConfig = mkOption {
        type = types.attrs;
        default = {};
      };
    };

    config = {
      extraConfig = lib.mkIf config.enableRecursiveResolver {
        zones = [
          {
            zone = ".";
            zone_type = "Hint";
            stores = {
              type = "recursor";
              # contains the list of toplevel DNS servers, from which to recursively resolve entries.
              roots = "${pkgs.dns-root-data}/root.hints";

              # dnssec, see: <https://github.com/hickory-dns/hickory-dns/issues/2193>
              # probably not needed: the default seems to be that dnssec is disabled
              # enable_dnssec = false;
              #
              # defaults, untuned
              # ns_cache_size = 1024;
              # record_cache_size = 1048576;
            };
          }
        ];
      };
    };
  });

  mkSystemdService = flavor: { includes, listenAddrsIpv4, listenAddrsIpv6, port, substitutions, extraConfig, ... }: let
    sed = "${pkgs.gnused}/bin/sed";
    configTemplate = toml.generate "trust-dns-${flavor}.toml" (
      (
        lib.filterAttrsRecursive (_: v: v != null) config.services.trust-dns.settings
      ) // {
        listen_addrs_ipv4 = listenAddrsIpv4;
        listen_addrs_ipv6 = listenAddrsIpv6;
      } // extraConfig
    );
    configPath = "/var/lib/trust-dns/${flavor}-config.toml";
    sedArgs = lib.mapAttrsToList (key: value: ''-e "s/${key}/${value}/g"'') substitutions;
    subs = lib.concatStringsSep " " sedArgs;
  in {
    description = "trust-dns Domain Name Server (serving ${flavor})";
    unitConfig.Documentation = "https://trust-dns.org/";
    after = [ "network.target" ];
    wantedBy = [ "network.target" ];

    preStart = lib.concatStringsSep "\n" (
      [''
        mkdir -p "/var/lib/trust-dns/${flavor}"
        ${sed} ${subs} -e "" "${configTemplate}" \
          | cat - \
            ${lib.concatStringsSep " " includes} \
            > "${configPath}" || true
      ''] ++ lib.mapAttrsToList (zone: { rendered, ... }: ''
        ${sed} ${subs} -e "" ${pkgs.writeText "${zone}.zone.in" rendered} \
          > "/var/lib/trust-dns/${flavor}/${zone}.zone"
      '') dns.zones
    );

    serviceConfig = config.systemd.services.trust-dns.serviceConfig // {
      ExecStart = lib.escapeShellArgs ([
        "${config.services.trust-dns.package}/bin/${config.services.trust-dns.package.meta.mainProgram}"
        "--port"     (builtins.toString port)
        "--zonedir"  "/var/lib/trust-dns/${flavor}"
        "--config"   "${configPath}"
      ] ++ lib.optionals config.services.trust-dns.debug [
        "--debug"
      ] ++ lib.optionals config.services.trust-dns.quiet [
        "--quiet"
      ]);
      # servo/dyn-dns needs /var/lib/uninsane/wan.txt.
      # this might not exist on other systems,
      # so just bind the deepest path which is guaranteed to exist.
      ReadOnlyPaths = [ "/var/lib" ];
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
      asSystemResolver = mkOption {
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
    services.trust-dns.settings.zones = [];  #< TODO: remove once upstreamed (bad default)

    # don't bind to IPv6 until i explicitly test that stack
    services.trust-dns.settings.listen_addrs_ipv6 = [];
    services.trust-dns.quiet = true;
    # FIXME(2023/11/26): services.trust-dns.debug doesn't log requests: use RUST_LOG=debug env for that.
    # - see: <https://github.com/hickory-dns/hickory-dns/issues/2082>
    # services.trust-dns.debug = true;

    services.trust-dns.package = pkgs.trust-dns.override {
      rustPlatform.buildRustPackage = args: pkgs.rustPlatform.buildRustPackage (args // {
        buildFeatures = [
          "recursor"
        ];

        # fix enough bugs inside the recursive resolver that it's compatible with my infra.
        # TODO: upstream these patches!
        src = pkgs.fetchFromGitea {
          domain = "git.uninsane.org";
          owner = "colin";
          repo = "hickory-dns";
          rev = "67649863faf2e08f63963a96a491a4025aaf8ed6";
          hash = "sha256-vmVY8C0cCCFxy/4+g1vKZsAD5lMaufIExnFaSVVAhGM=";
        };
        cargoHash = "sha256-FEjNxv1iu27SXQhz1+Aehs4es8VxT1BPz5uZq8TcG/k=";
      });
    };

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
          # there can be a lot of restarts as interfaces toggle,
          # particularly around the DHCP/NetworkManager stuff.
          StartLimitBurst = 60;
        };
        # trust-dns.unitConfig.StartLimitIntervalSec = 60;
      }
      (lib.mapAttrs'
        (flavor: instanceConfig: {
          name = "trust-dns-${flavor}";
          value = mkSystemdService flavor instanceConfig;
        })
        cfg.instances
      )
    ];

    environment.etc."NetworkManager/dispatcher.d/60-trust-dns-nmhook" = lib.mkIf cfg.asSystemResolver {
      source = "${trust-dns-nmhook}/bin/trust-dns-nmhook";
    };

    sane.services.trust-dns.instances.localhost = lib.mkIf cfg.asSystemResolver {
      listenAddrsIpv4 = [ "127.0.0.1" ];
      listenAddrsIpv6 = [ "::1" ];
      enableRecursiveResolver = true;
      # append zones discovered via DHCP to the resolver config.
      includes = [ "/var/lib/trust-dns/dhcp-configs/*" ];
    };
    networking.nameservers = lib.mkIf cfg.asSystemResolver [
      "127.0.0.1"
      "::1"
    ];
    services.resolved.enable = lib.mkIf cfg.asSystemResolver (lib.mkForce false);
  };
}
