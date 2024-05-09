{ config, lib, pkgs, ... }:
let
  cfg = config.sane.programs.swayidle;
  idleAction = with lib; types.submodule ({ config, name, ... }: {
    options.enable = mkOption {
      type = types.bool;
      default = true;
    };
    options.command = mkOption {
      type = types.str;
      default = name;
      description = ''
        shell command to run, e.g. "swaylock --indicator-idle-visible".
      '';
    };
    options.desktop = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        name of a .desktop file to launch, e.g. "swaylock.desktop".
      '';
    };
    options.service = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        name of a user service to start.
      '';
    };
    options.delay = mkOption {
      type = types.int;
      description = ''
        how many seconds of idle time before triggering the command.
      '';
    };
    config.command = lib.mkMerge [
      (lib.mkIf (config.desktop != null) (
        lib.escapeShellArgs [ "sane-open" "--application" "${config.desktop}" ])
      )
      (lib.mkIf (config.service != null) (
        lib.escapeShellArgs [ "s6-rc" "start" "${config.service}" ])
      )
    ];
  });
  screenOff = pkgs.writeShellScriptBin "screen-off" ''
    swaymsg -- output '*' power false
    swaymsg -- input type:touch events disabled
  '';
in
{
  sane.programs.swayidle = {
    configOption = with lib; mkOption {
      default = {};
      type = types.submodule {
        options.actions = mkOption {
          type = types.attrsOf idleAction;
          default = {};
        };
      };
    };

    config.actions.screenoff = {
      # XXX: this turns the screen/touch off, and then there's no way to turn it back ON
      # unless you've configured that elsewhere (e.g. sane-input-handler)
      enable = lib.mkDefault false;
      command = "${screenOff}/bin/screen-off";
      delay = lib.mkDefault 1500;  # 1500s = 25min
    };
    config.actions.lock = {
      # define a well-known action mostly to prevent accidentally shipping overlapping screen lockers...
      delay = lib.mkDefault 1800;  # 1800 = 30min
      # enable by default, but only if something else has installed a locker.
      enable = lib.mkDefault cfg.actions.lock.command != "";
      command = lib.mkDefault "";
    };

    sandbox.method = "bwrap";
    sandbox.whitelistDbus = [ "user" ];  #< might need system too, for inhibitors
    sandbox.whitelistS6 = true;
    sandbox.whitelistWayland = true;
    sandbox.extraRuntimePaths = [ "sway" ];

    services.swayidle = {
      description = "swayidle: perform actions when sway session is idle";
      partOf = [ "graphical-session" ];

      command = lib.escapeShellArgs (
        [
          "swayidle"
          "-w"
        ] ++ lib.flatten (
          lib.mapAttrsToList
            (_: { command, delay, enable, ... }: lib.optionals enable [
              "timeout"
              (builtins.toString delay)
              command
            ])
            cfg.config.actions
        )
      );
    };
  };
}
