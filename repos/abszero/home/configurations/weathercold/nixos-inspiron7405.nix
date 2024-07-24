{ lib, ... }:

let
  inherit (builtins) readDir;
  inherit (lib) optionalAttrs;

  modules = {
    main = {
      imports = [
        ({ config, lib, ... }: lib.mkIf (config.specialisation != { }) modules.hyprland-latte-pink)
      ];

      abszero.profiles.full.enable = true;

      specialisation.plasma6-latte-pink.configuration = modules.plasma6-latte-pink;
    };

    hyprland-latte-pink = {
      abszero = {
        profiles.hyprland.enable = true;
        themes = {
          base = {
            firefox.verticalTabs = true;
            nushell.enable = true;
          };
          catppuccin = {
            fcitx5.enable = true;
            foot.enable = true;
            hyprland.enable = true;
            hyprpaper.nixosLogo = true;
            pointerCursor.enable = true;
          };
        };
      };

      catppuccin.accent = "pink";

      wayland.windowManager.hyprland.settings.monitor = "eDP-1, preferred, auto, 1.25";
    };

    plasma6-latte-pink = {
      abszero = {
        services.desktopManager.plasma6.enable = true;
        themes = {
          base = {
            firefox.verticalTabs = true;
            nushell.enable = true;
          };
          catppuccin = {
            foot.enable = true;
            plasma.enable = true;
          };
          colloid.fcitx5.enable = true;
        };
      };

      catppuccin.accent = "pink";
    };
  };
in

# No-op if _base.nix is hidden
optionalAttrs (readDir ./. ? "_base.nix") {
  imports = [ ../_options.nix ];

  homeConfigurations."weathercold@nixos-inspiron7405" = {
    system = "x86_64-linux";
    modules = [
      # inputs.bocchi-cursors.homeModules.bocchi-cursors-shadowBlack
      (import ./_base.nix { inherit lib; })
      modules.main
    ];
  };
}
