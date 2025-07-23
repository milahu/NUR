{ ... }:
let
  proxiedCommon = {
    fromContainer = "static-stuff";
    port = 80;
  };
in
{
  vacu.proxiedServices.static-stuff-tulpaudcast = {
    domain = "tulpaudcast.jean-luc.org";
  } // proxiedCommon;
  vacu.proxiedServices.static-stuff-mira = {
    domain = "shelvacu.miras.pet";
  } // proxiedCommon;
  vacu.proxiedServices.static-stuff-gab = {
    domain = "gabriel-dropout.for.miras.pet";
  } // proxiedCommon;

  systemd.tmpfiles.settings.asdf."/trip/static-stuff".d = {
    mode = "0744";
  };

  containers.static-stuff = {
    privateNetwork = true;
    hostAddress = "192.168.100.18";
    localAddress = "192.168.100.19";

    autoStart = true;
    ephemeral = true;
    restartIfChanged = true;
    bindMounts."/static-stuff" = {
      hostPath = "/trip/static-stuff";
      isReadOnly = true;
    };

    config = {
      system.stateVersion = "23.11";
      networking.firewall.enable = false;

      systemd.tmpfiles.settings."asdf"."/static-stuff"."Z".mode = "0555";

      services.nginx.enable = true;
      services.nginx.virtualHosts = {
        "tulpaudcast.jean-luc.org".root = "/static-stuff/tulpaudcast.jean-luc.org";
        "shelvacu.miras.pet".extraConfig = ''
          default_type text/plain;
          return 200 "I don't know what to put here";
        '';
        "gabriel-dropout.for.miras.pet" = {
          root = "/static-stuff/gabriel-dropout.for.miras.pet";
          extraConfig = "autoindex on;";
        };
      };
    };
  };
}
