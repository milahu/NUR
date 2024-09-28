{ inputs, lib, ... }:

let
  inherit (builtins) readDir;
  inherit (lib) optionalAttrs;

  mainModule =
    { pkgs, ... }:
    {
      abszero = {
        profiles.hyprland.enable = true;
        themes = {
          base = {
            fastfetch.enable = true;
            firefox.verticalTabs = true;
            # hyprland.dynamicCursors.enable = true;
            nushell.enable = true;
          };
          catppuccin = {
            fcitx5.enable = true;
            foot.enable = true;
            gtk.enable = true;
            hyprland.enable = true;
            hyprpaper.nixosLogo = true;
            pointerCursor.enable = true;
          };
        };
      };

      catppuccin.accent = "pink";

      # Ping nixpkgs to the locked version
      nix.registry.nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        flake = inputs.nixpkgs;
      };

      # Do not install hyprland because it is installed with pacman
      wayland.windowManager.hyprland.package = pkgs.emptyDirectory // {
        override = _: pkgs.emptyDirectory;
      };

      gtk.catppuccin.icon.enable = true;
    };
in

# No-op if _base.nix is hidden
optionalAttrs (readDir ./. ? "_base.nix") {
  imports = [ ../_options.nix ];

  homeConfigurations."weathercold@arch-disk" = {
    system = "x86_64-linux";
    modules = [
      # inputs.bocchi-cursors.homeModules.bocchi-cursors-shadowBlack
      (import ./_base.nix { inherit lib; })
      mainModule
    ];
  };
}
