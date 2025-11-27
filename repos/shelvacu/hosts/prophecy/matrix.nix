{ config, vaculib, ... }:
let
  socketDir = "/run/matrix-unix-socket";
  socketPath = "${socketDir}/socket.unix";
in
{
  systemd.tmpfiles.settings.whatever.${socketDir}.d = {
    user = config.services.matrix-continuwuity.user;
    group = "caddy";
    mode = vaculib.modeStr {
      user = "all";
      group = {
        read = true;
        execute = true;
      };
    };
  };

  services.matrix-continuwuity = {
    enable = true;
    settings.global = {
      unix_socket_path = socketPath;
      unix_socket_perms = vaculib.modeStr { all = "all"; };
      server_name = "sv.mt";
      allow_federation = true;
      allow_announcements_check = false;
    };
  };

  services.caddy.virtualHosts.
}
