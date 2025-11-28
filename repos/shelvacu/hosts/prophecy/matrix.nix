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
      new_user_displayname-suffix = "";
      ip_lookup_strategy = 1;
      log_colors = false;
    };
  };

  services.caddy.virtualHosts."matrix.shelvacu.com" = {
    vacu.hsts = "preload";
    extraConfig = ''
      reverse_proxy unix/${socketPath}
    '';
  };
}
