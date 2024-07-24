{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.abszero.modules) mkExternalEnableOption;
  cfg = config.abszero.themes.catppuccin;
in

{
  imports = [ ../../../../lib/modules/config/abszero.nix ];

  options.abszero.themes.catppuccin.fonts.enable = mkExternalEnableOption config "fonts to use with catppuccin theme";

  config = mkIf cfg.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      open-sans
      noto-fonts-cjk-sans
      fira-code
      inconsolata
      (iosevka-bin.override { variant = "Etoile"; })
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
  };
}
