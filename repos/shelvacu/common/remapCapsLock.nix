{
  pkgs,
  lib,
  config,
  vacuModuleType,
  ...
}:
let
  inherit (lib) mkOption types;
in
lib.optionalAttrs (vacuModuleType == "nixos") {
  options.vacu.enableCapsLockRemap = mkOption {
    type = types.bool;
    default = config.vacu.isGui;
  };
  config = lib.mkIf config.vacu.enableCapsLockRemap {
    # https://discourse.nixos.org/t/best-way-to-remap-caps-lock-to-esc-with-wayland/39707/6
    services.interception-tools =
      let
        itools = pkgs.interception-tools;
        itools-caps = pkgs.interception-tools-plugins.caps2esc;
      in
      {
        enable = true;
        plugins = [ itools-caps ];
        # requires explicit paths: https://github.com/NixOS/nixpkgs/issues/126681
        udevmonConfig = pkgs.lib.mkDefault ''
          - JOB: "${itools}/bin/intercept -g $DEVNODE | ${itools-caps}/bin/caps2esc -m 1 | ${itools}/bin/uinput -d $DEVNODE"
            DEVICE:
              EVENTS:
                EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        '';
      };
  };
}
