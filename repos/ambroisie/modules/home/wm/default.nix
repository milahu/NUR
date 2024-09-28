{ config, lib, pkgs, ... }:
let
  mkRelatedOption = description: relatedWMs:
    let
      isActivatedWm = wm: config.my.home.wm.windowManager == wm;
    in
    (lib.mkEnableOption description) // {
      default = builtins.any isActivatedWm relatedWMs;
    };
in
{
  imports = [
    ./cursor
    ./dunst
    ./i3
    ./i3bar
    ./rofi
    ./screen-lock
  ];

  options.my.home.wm = with lib; {
    windowManager = mkOption {
      type = with types; nullOr (enum [ "i3" ]);
      default = null;
      example = "i3";
      description = "Which window manager to use for home session";
    };

    cursor = {
      enable = mkRelatedOption "dunst configuration" [ "i3" ];
    };

    dunst = {
      enable = mkRelatedOption "dunst configuration" [ "i3" ];
    };

    i3bar = {
      enable = mkRelatedOption "i3bar configuration" [ "i3" ];

      vpn = {
        enable = my.mkDisableOption "VPN configuration";

        blockConfigs = mkOption {
          type = with types; listOf (attrsOf str);
          default = [
            {
              active_format = " VPN ";
              service = "wg-quick-wg";
            }
            {
              active_format = " VPN (LAN) ";
              service = "wg-quick-lan";
            }
          ];
          example = [
            {
              active_format = " WORK ";
              service = "some-service-name";
            }
          ];
          description = "list of block configurations, merged with the defaults";
        };
      };
    };

    rofi = {
      enable = mkRelatedOption "rofi menu" [ "i3" ];
    };

    screen-lock = {
      enable = mkRelatedOption "automatic X screen locker" [ "i3" ];

      command = mkOption {
        type = types.str;
        default = "${lib.getExe pkgs.i3lock} -n -c 000000";
        example = "\${lib.getExe pkgs.i3lock} -n -i lock.png";
        description = "Locker command to run";
      };

      cornerLock = {
        enable = my.mkDisableOption ''
          Move mouse to upper-left corner to lock instantly, lower-right corner to
          disable auto-lock.
        '';

        delay = mkOption {
          type = types.int;
          default = 5;
          example = 15;
          description = "How many seconds before locking this way";
        };
      };

      notify = {
        enable = my.mkDisableOption "Notify when about to lock the screen";

        delay = mkOption {
          type = types.int;
          default = 5;
          example = 15;
          description = ''
            How many seconds in advance should there be a notification.
            This value must be at lesser than or equal to `cornerLock.delay`
            when both options are enabled.
          '';
        };
      };

      timeout = mkOption {
        type = types.ints.between 1 60;
        default = 15;
        example = 1;
        description = "Inactive time interval to lock the screen automatically";
      };
    };
  };
}
