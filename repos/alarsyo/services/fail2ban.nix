{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.my.services.fail2ban;
in {
  options.my.services.fail2ban = {
    enable = mkEnableOption "Enable fail2ban";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      bantime = "6h";
      bantime-increment.enable = true;
      jails.DEFAULT.settings.findtime = "6h";
    };
  };
}
