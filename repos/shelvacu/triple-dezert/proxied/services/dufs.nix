{ ... }:
{
  vacu.proxiedServices.dufs = {
    domain = "dav.shelvacu.com";
    fromContainer = "dufs";
    port = 80;
  };

  containers.dufs = {
    privateNetwork = true;
    hostAddress = "192.168.100.30";
    localAddress = "192.168.100.31";

    autoStart = true;
    ephemeral = true;
    restartIfChanged = true;
    bindMounts."/trip" = {
      hostPath = "/trip";
      isReadOnly = true;
    };

    config =
      { pkgs, lib, ... }:
      let
        dufsConfig = {
          bind = "0.0.0.0";
          port = 80;
          allow-all = false;
          allow-upload = false;
          allow-delete = false;
          allow-search = true;
          allow-symlink = false;
          allow-archive = true;
          enable-cors = false;
          render-try-index = true;
          render-spa = true;
          serve-path = "/trip";

          auth = [
            "s:$6$WNI1472ebgQg9zjk$4qeOLarhHJNxNHaAkzztJMN8fzOb6iQm7KTp0SuvYWSvfFORjcNSXNBsKTLRSox2LOSYYwWSyYv/u6lQ9VstF1@/:ro"
          ];
        };
        dufsConfigFile = pkgs.writeText "dufs-config.yaml" (builtins.toJSON dufsConfig);
      in
      {
        system.stateVersion = "24.05";
        networking.firewall.allowedTCPPorts = [ 80 ];
        systemd.services.dufs = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
          description = "dufs server";
          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.dufs} --config ${dufsConfigFile}";
          };
        };
      };
  };
}
