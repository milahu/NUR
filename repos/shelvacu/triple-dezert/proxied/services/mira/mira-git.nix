{ config, ... }:
let
  container = config.containers.mira-git;
  domain = "git.for.miras.pet";
  port = 80;
  dbCfg = config.vacu.databases.mira-git;
in
{
  vacu.databases.mira-git = {
    fromContainer = "mira-git";
  };

  vacu.proxiedServices.mira-git = {
    inherit domain port;
    fromContainer = "mira-git";
    forwardFor = true;
    maxConnections = 100;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # networking.nat.forwardPorts = [
  #   {
  #     destination = container.localAddress;
  #     proto = "tcp";
  #     sourcePort = 22;
  #   }
  # ];

  containers.frontproxy.config.services.haproxy.config = ''
    frontend ssh
      bind :22
      timeout client 10s
      default_backend miragit

    backend miragit
      timeout server 30s
      timeout connect 10s
      server server1 ${container.localAddress}:22
  '';

  containers.mira-git = {
    privateNetwork = true;
    hostAddress = "192.168.100.40";
    localAddress = "192.168.100.41";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;

    bindMounts."/mira-git" = {
      hostPath = "/trip/mira-git";
      isReadOnly = false;
    };

    # forwardPorts = [
    #   {
    #     containerPort = 22;
    #     hostPort = 22;
    #     protocol = "tcp";
    #   }
    # ];

    config =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      let
        forgejo = config.services.forgejo;
        env_vars = [
          "USER=${forgejo.user}"
          "HOME=${forgejo.stateDir}"
          "FORGEJO_WORK_DIR=${forgejo.stateDir}"
          "FORGEJO_CUSTOM=${forgejo.customDir}"
        ];
        forgejo_bin = lib.getExe forgejo.package;
        admin_script = pkgs.writeScriptBin "forgejo_run" ''
          sudo -u ${forgejo.user} ${lib.escapeShellArgs env_vars} ${forgejo_bin} -- "$@"
        '';
      in
      {
        system.stateVersion = "24.11";

        networking.firewall.enable = false;
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        systemd.services.forgejo.serviceConfig = {
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          PrivateUsers = lib.mkForce false;
        };

        environment.systemPackages = [ admin_script ];

        services.forgejo = {
          enable = true;
          package = pkgs.forgejo;
          stateDir = "/trip/mira-git";
          database = {
            type = "postgres";
            inherit (dbCfg) user name;
            host = container.hostAddress;
            createDatabase = false;
          };
          lfs.enable = true;
          settings = {
            DEFAULT.APP_NAME = "Cultists' Git";
            repository = {
              DEFAULT_PRIVATE = "private";
              DEFAULT_PUSH_CREATE_PRIVATE = true;
              ENABLE_PUSH_CREATE_USER = true;
              ENABLE_PUSH_CREATE_ORG = true;
              DEFAULT_BRANCH = "master";
            };
            ui = {
              SHOW_USER_EMAIL = false;
              AMBIGUOUS_UNICODE_DETECTION = true;
            };
            "ui.meta" = {
              AUTHOR = "Mira Cult";
              DESCRIPTION = "Mira/acc";
              KEYWORDS = "";
            };
            markdown.CUSTOM_URL_SCHEMES = "ftp,sftp,ftps,git,ssh";
            server = {
              DOMAIN = domain;
              ROOT_URL = "https://${domain}/";
              HTTP_PORT = port;
              START_SSH_SERVER = true;
              BUILTIN_SSH_SERVER_USER = "git";
              SSH_CREATE_AUTHORIZED_KEYS_FILE = false;
              SSH_SERVER_HOST_KEYS = "ssh/gitea.rsa, ssh/gitea.ed25519";
            };
            admin = {
              DEFAULT_EMAIL_NOTIFICATIONS = "disabled";
              USER_DISABLED_FEATURES = "deletion";
            };
            # todo: oauth against kanidm, security.ENABLE_INTERNAL_SIGNIN = false
            security = {
              INSTALL_LOCK = true;
              REVERSE_PROXY_TRUSTED_PROXIES = "${container.hostAddress}";
              REQUIRE_SIGNIN_VIEW = true;
              DEFAULT_KEEP_EMAIL_PRIVATE = true;
            };
            service = {
              DISABLE_REGISTRATION = true;
              REQUIRE_SIGNIN_VIEW = true;
            };
            session.COOKIE_SECURE = true;
            api.ENABLE_SWAGGER = false;
            oauth2.ENABLED = false;
            time.DEFAULT_UI_LOCATION = "UTC";
            federation.ENABLED = false;
            actions.ENABLED = false;
            #todo: actions/cli maybe?
            #todo: mailer
          };
        };
      };
  };
}
