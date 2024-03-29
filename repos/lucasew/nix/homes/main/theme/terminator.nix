{ pkgs, lib, config, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (pkgs.custom) colors;
  inherit (colors.colors) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
in {
  # terminator_config(5)
  programs.terminator.config = lib.mkIf config.programs.terminator.enable {
    profiles.default = {
      audible_bell = true;
      background_color = "#${base00}";
      foreground_color = "#${base05}";
      cursor_color = "#${base06}";
      pallete = concatStringsSep ":" (map (i: "#${i}") [
        base00
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base06
        "65737e"
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base07
      ]);
      font = "Monospace 10";
      use_system_font = false;
      use_theme_colors = true;
    };
    global_config = {
      title_transmit_fg_color = "#${base05}";
      title_transmit_bg_color = "#${base02}";
      title_inactive_fg_color = "#${base05}";
      title_inactive_bg_color = "#${base00}";
    };
  };
}
