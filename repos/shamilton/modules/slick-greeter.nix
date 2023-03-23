{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.slick;
  slick-greeter = with pkgs.gnome3; pkgs.callPackage ./../pkgs/slick-greeter {
    inherit gnome-common gtk slick-greeter;
  };
in
{
  meta = {
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
  };

  options = {

    services.xserver.displayManager.lightdm.greeters.slick = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable linuxmint-greeter as the lightdm greeter.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = slick-greeter.xgreeters;
      name = "slick-greeter";
    };

    # Show manual login card.
    # services.xserver.displayManager.lightdm.extraSeatDefaults = "greeter-show-manual-login=true";

    # environment.etc."lightdm/io.elementary.greeter.conf".source = "${pkgs.pantheon.elementary-greeter}/etc/lightdm/io.elementary.greeter.conf";
    # environment.etc."wingpanel.d/io.elementary.greeter.allowed".source = "${pkgs.pantheon.elementary-default-settings}/etc/wingpanel.d/io.elementary.greeter.allowed";

  };
}
