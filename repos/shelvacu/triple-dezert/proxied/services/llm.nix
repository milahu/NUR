{ config, ... }:
let
  contain = config.containers.llm;
in
{
  vacu.proxiedServices.llm = {
    domain = "llm.shelvacu.com";
    fromContainer = "llm";
    port = contain.config.services.open-webui.port;
  };

  systemd.tmpfiles.settings.whatever."/trip/llm-models".d = {
    mode = "0744";
  };

  containers.llm = {
    privateNetwork = true;
    hostAddress = "192.168.100.26";
    localAddress = "192.168.100.27";

    autoStart = true;
    ephemeral = false;
    restartIfChanged = true;
    bindMounts."/models" = {
      hostPath = "/trip/llm-models";
      isReadOnly = false;
    };

    config =
      let
        outer_config = config;
      in
      { config, ... }:
      {
        system.stateVersion = "24.05";
        networking.useHostResolvConf = false;
        networking.nameservers = [ "10.78.79.1" ];
        networking.firewall.enable = false;

        systemd.tmpfiles.settings."asdf"."/models"."Z" = {
          mode = "0700";
          user = "ollama";
          group = "ollama";
        };

        services.open-webui = {
          enable = true;
          port = 8080;
          host = "0.0.0.0";
          environment = {
            OLLAMA_API_BASE_URL = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
            ENV = "prod";
            WEBUI_URL = "https://${outer_config.vacu.proxiedServices.llm.domain}/";
            ENABLE_COMMUNITY_SHARING = "False";
            # DATABASE_URL = "postgresql://open-webui:password@${contain.hostAddress}/open-webui";
            SAFE_MODE = "False";
            WEBUI_SESSION_COOKIE_SAME_SITE = "strict";
            WEBUI_SESSION_COOKIE_SECURE = "True";
            ENABLE_OPENAI_API = "False";
          };
        };
        services.ollama = {
          enable = true;
          host = "127.0.0.1";
          port = 11434;
          models = "/models";
          user = "ollama";
          group = "ollama";
          acceleration = false;
        };
      };
  };
}
