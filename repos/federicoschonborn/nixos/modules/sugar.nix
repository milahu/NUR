{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.desktopManager.sugar;
in

{
  options.services.desktopManager.sugar = {
    enable = lib.mkEnableOption "Sugar";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ (import ../overlay.nix) ];

    environment.systemPackages = [
      pkgs.sugar
      pkgs.sugar-artwork
      pkgs.sugar-toolkit-gtk3 # sugar-activity3
      pkgs.metacity
      pkgs.sugar-terminal-activity
    ];

    environment.pathsToLink = [ "/share" ];

    services.xserver.enable = lib.mkDefault true;
    services.xserver.displayManager.lightdm.enable = lib.mkDefault true;

    # Required services
    services.telepathy.enable = true;
    programs.dconf.enable = true;

    # Optional services
    services.upower.enable = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;

    services.dbus.enable = true;
    services.dbus.packages = [
      pkgs.sugar-datastore
    ];

    services.displayManager.sessionPackages = [
      pkgs.sugar
    ];
  };
}
