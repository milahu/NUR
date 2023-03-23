# A low-ressource, full-featured git forge.
{ config, lib, ... }:
let
  cfg = config.my.services.gitea;
in
{
  options.my.services.gitea = with lib; {
    enable = mkEnableOption "Gitea";
    port = mkOption {
      type = types.port;
      default = 3042;
      example = 8080;
      description = "Internal port";
    };
    mail = {
      enable = mkEnableOption {
        description = "mailer configuration";
      };
      host = mkOption {
        type = types.str;
        example = "smtp.example.com:465";
        description = "Host for the mail account";
      };
      user = mkOption {
        type = types.str;
        example = "gitea@example.com";
        description = "User for the mail account";
      };
      passwordFile = mkOption {
        type = types.str;
        example = "/run/secrets/gitea-mail-password.txt";
        description = "Password for the mail account";
      };
      type = mkOption {
        type = types.str;
        default = "smtp";
        example = "smtp";
        description = "Password for the mail account";
      };
      tls = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Use TLS for connection";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea =
      let
        inherit (config.networking) domain;
        giteaDomain = "git.${domain}";
      in
      {
        enable = true;

        appName = "Ambroisie's forge";
        httpPort = cfg.port;
        domain = giteaDomain;
        rootUrl = "https://${giteaDomain}";

        user = "git";
        lfs.enable = true;

        useWizard = false;

        database = {
          type = "postgres"; # Automatic setup
          user = "git"; # User needs to be the same as gitea user
        };

        # NixOS module uses `gitea dump` to backup repositories and the database,
        # but it produces a single .zip file that's not very backup friendly.
        # I configure my backup system manually below.
        dump.enable = false;

        mailerPasswordFile = lib.mkIf cfg.mail.enable cfg.mail.passwordFile;

        settings = {
          mailer = lib.mkIf cfg.mail.enable {
            ENABLED = true;
            HOST = cfg.mail.host;
            FROM = cfg.mail.user;
            USER = cfg.mail.user;
            MAILER_TYPE = cfg.mail.type;
            IS_TLS_ENABLED = cfg.mail.tls;
          };

          service = {
            DISABLE_REGISTRATION = true;
          };

          session = {
            # only send cookies via HTTPS
            COOKIE_SECURE = true;
          };
        };
      };

    users.users.git = {
      description = "Gitea Service";
      home = config.services.gitea.stateDir;
      useDefaultShell = true;
      group = "git";

      # The service for gitea seems to hardcode the group as
      # gitea, so, uh, just in case?
      extraGroups = [ "gitea" ];

      isSystemUser = true;
    };
    users.groups.git = { };

    my.services.nginx.virtualHosts = [
      # Proxy to Gitea
      {
        subdomain = "git";
        inherit (cfg) port;
      }
      # Redirect `gitea.` to actual forge subdomain
      {
        subdomain = "gitea";
        redirect = config.services.gitea.rootUrl;
      }
    ];

    my.services.backup = {
      paths = [
        config.services.gitea.lfs.contentDir
        config.services.gitea.repositoryRoot
      ];
    };

    services.fail2ban.jails = {
      gitea = ''
        enabled = true
        filter = gitea
        action = iptables-allports
      '';
    };

    environment.etc = {
      "fail2ban/filter.d/gitea.conf".text = ''
        [Definition]
        failregex = ^.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>$
        journalmatch = _SYSTEMD_UNIT=gitea.service
      '';
    };
  };
}
