{
  lib,
  pkgs,
  config,
  ...
}:
let
  domain = "chat.for.miras.pet";
  port = 3169;
  secrets_folder = "/var/lib/vacu-secrets/mira-chat";
  services = [
    "docker-mira-chat-database.service"
    "docker-mira-chat-memcached.service"
    "docker-mira-chat-rabbitmq.service"
    "docker-mira-chat-redis.service"
    "docker-mira-chat-zulip.service"
  ];
in
{
  vacu.proxiedServices.mira-chat = {
    inherit domain port;
    forwardFor = true;
    maxConnections = 100;
    ipAddress = "127.0.0.1";
  };

  sops.secrets.miracult-zulip-email-password = { };
  sops.templates."zulip-secrets".content = ''
    SECRETS_email_password=${config.sops.placeholder.miracult-zulip-email-password}
  '';

  systemd.services.make-mira-chat-secrets = {
    before = services;
    requiredBy = services;
    serviceConfig.Type = "oneshot";
    script = ''
      set -e

      dir="${secrets_folder}"
      if [[ -f "$dir/zulip-secrets" ]]; then
        exit 0
      fi
      function mkpass() {
        tr -dc 'A-F0-9' < /dev/urandom | head -c64
      }
      postgres_password="$(mkpass)"
      memcache_password="$(mkpass)"
      rabbitmq_password="$(mkpass)"
      redis_password="$(mkpass)"
      secret_key="$(mkpass)"

      umask 0077
      mkdir -p "$dir"
      cat <<END > "$dir/postgres-secrets"
        POSTGRES_PASSWORD=$postgres_password
      END
      cat <<END > "$dir/memcache-secrets"
        MEMCACHED_PASSWORD=$memcache_password
      END
      cat <<END > "$dir/rabbitmq-secrets"
        RABBITMQ_DEFAULT_PASS=$rabbitmq_password
      END
      cat <<END > "$dir/redis-secrets"
        REDIS_PASSWORD=$redis_password
      END
      cat <<END > "$dir/zulip-secrets"
        SECRETS_memcached_password=$memcache_password
        SECRETS_postgres_password=$postgres_password
        SECRETS_rabbitmq_password=$rabbitmq_password
        SECRETS_redis_password=$redis_password
        SECRETS_secret_key=$secret_key
      END
    '';
  };

  # originally generated with compose2nix on https://github.com/zulip/docker-zulip/blob/93860928283e36eaf9a67805a4cc5ab1bf07e983/docker-compose.yml
  virtualisation.oci-containers.containers."mira-chat-database" = {
    image = "zulip/zulip-postgresql:14";
    environment = {
      "POSTGRES_DB" = "zulip";
      "POSTGRES_USER" = "zulip";
    };
    environmentFiles = [ (secrets_folder + "/postgres-secrets") ];
    volumes = [ "mira-chat_postgresql-14:/var/lib/postgresql/data:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=database"
      "--network=mira-chat_default"
    ];
  };
  systemd.services."docker-mira-chat-database" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_postgresql-14.service"
    ];
    requires = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_postgresql-14.service"
    ];
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  virtualisation.oci-containers.containers."mira-chat-memcached" = {
    image = "memcached:alpine";
    environment = {
      "MEMCACHED_SASL_PWDB" = "/home/memcache/memcached-sasl-db";
      "SASL_CONF_PATH" = "/home/memcache/memcached.conf";
    };
    environmentFiles = [ (secrets_folder + "/memcache-secrets") ];
    cmd = [
      "sh"
      "-euc"
      "echo 'mech_list: plain' > \"$SASL_CONF_PATH\"\n  echo \"zulip@$HOSTNAME:$MEMCACHED_PASSWORD\" > \"$MEMCACHED_SASL_PWDB\"\n  echo \"zulip@localhost:$MEMCACHED_PASSWORD\" >> \"$MEMCACHED_SASL_PWDB\"\n  exec memcached -S\n  "
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=memcached"
      "--network=mira-chat_default"
    ];
  };
  systemd.services."docker-mira-chat-memcached" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [ "docker-network-mira-chat_default.service" ];
    requires = [ "docker-network-mira-chat_default.service" ];
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  virtualisation.oci-containers.containers."mira-chat-rabbitmq" = {
    image = "rabbitmq:3.12.14";
    environment = {
      "RABBITMQ_DEFAULT_USER" = "zulip";
    };
    environmentFiles = [ (secrets_folder + "/rabbitmq-secrets") ];
    volumes = [ "mira-chat_rabbitmq:/var/lib/rabbitmq:rw" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=rabbitmq"
      "--network=mira-chat_default"
    ];
  };
  systemd.services."docker-mira-chat-rabbitmq" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_rabbitmq.service"
    ];
    requires = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_rabbitmq.service"
    ];
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  virtualisation.oci-containers.containers."mira-chat-redis" = {
    image = "redis:alpine";
    environmentFiles = [ (secrets_folder + "/redis-secrets") ];
    volumes = [ "mira-chat_redis:/data:rw" ];
    cmd = [
      "sh"
      "-euc"
      "echo \"requirepass '$REDIS_PASSWORD'\" > /etc/redis.conf\n  exec redis-server /etc/redis.conf\n  "
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=redis"
      "--network=mira-chat_default"
    ];
  };
  systemd.services."docker-mira-chat-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_redis.service"
    ];
    requires = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_redis.service"
    ];
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  virtualisation.oci-containers.containers."mira-chat-zulip" = {
    image = "zulip/docker-zulip:9.4-0";
    environment = {
      "DB_HOST" = "database";
      "DB_HOST_PORT" = "5432";
      "DB_USER" = "zulip";
      "DISABLE_HTTPS" = "True";
      "SETTING_EMAIL_HOST" = "smtp.shelvacu.com";
      "SETTING_EMAIL_HOST_USER" = "miracult-zulip";
      "SETTING_EMAIL_PORT" = "465";
      "SETTING_EMAIL_USE_SSL" = "True";
      "SETTING_EMAIL_USE_TLS" = "False";
      "SETTING_EXTERNAL_HOST" = domain;
      "SETTING_ENABLE_GRAVATAR" = "False";
      "SETTING_MEMCACHED_LOCATION" = "memcached:11211";
      "SETTING_PROMOTE_SPONSORING_ZULIP" = "False";
      "SETTING_RABBITMQ_HOST" = "rabbitmq";
      "SETTING_REDIS_HOST" = "redis";
      "SETTING_SOCIAL_AUTH_OIDC_FULL_NAME_VALIDATED" = "True";
      "SETTING_ZULIP_ADMINISTRATOR" = "zulip-notify@chat.for.miras.pet";
      "SETTING_NOREPLY_EMAIL_ADDRESS" = "zulip-notify@chat.for.miras.pet";
      "SETTING_ADD_TOKENS_TO_NOREPLY_ADDRESS" = "False";
      "SSL_CERTIFICATE_GENERATION" = "self-signed";
      "LOADBALANCER_IPS" = "172.18.0.1";
      "ZULIP_AUTH_BACKENDS" = "GenericOpenIdConnectBackend";
      "ZULIP_CUSTOM_SETTINGS" = ''
        SOCIAL_AUTH_OIDC_ENABLED_IDPS = {
          "kanidm": {
            "oidc_url": "https://auth.for.miras.pet/oauth2/openid/zulip",
            "display_name": "Mira Cult SSO",
            "client_id": "zulip",
            "secret": get_secret("social_auth_oidc_secret"),
            "auto_signup": True,
          }
        }
      '';
    };
    environmentFiles = [
      (secrets_folder + "/zulip-secrets")
      config.sops.templates."zulip-secrets".path
    ];
    volumes = [ "mira-chat_zulip:/data:rw" ];
    ports = [ "${toString port}:80/tcp" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=zulip"
      "--network=mira-chat_default"
    ];
  };
  systemd.services."docker-mira-chat-zulip" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_zulip.service"
    ];
    requires = [
      "docker-network-mira-chat_default.service"
      "docker-volume-mira-chat_zulip.service"
    ];
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };

  # Networks
  systemd.services."docker-network-mira-chat_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f mira-chat_default";
    };
    script = ''
      docker network inspect mira-chat_default || docker network create mira-chat_default
    '';
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-mira-chat_postgresql-14" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect mira-chat_postgresql-14 || docker volume create mira-chat_postgresql-14
    '';
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  systemd.services."docker-volume-mira-chat_rabbitmq" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect mira-chat_rabbitmq || docker volume create mira-chat_rabbitmq
    '';
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  systemd.services."docker-volume-mira-chat_redis" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect mira-chat_redis || docker volume create mira-chat_redis
    '';
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };
  systemd.services."docker-volume-mira-chat_zulip" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect mira-chat_zulip || docker volume create mira-chat_zulip
    '';
    partOf = [ "docker-compose-mira-chat-root.target" ];
    wantedBy = [ "docker-compose-mira-chat-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-mira-chat-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
