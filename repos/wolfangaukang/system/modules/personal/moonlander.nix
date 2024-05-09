{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.profile.moonlander;

in
{
  meta.maintainers = [ wolfangaukang ];

  options.profile.moonlander = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enables Moonlander Mark I support on NixOS
      '';
    };
    ignoreLayoutSettings = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Ignores any system layout settings (uses US Basic)
      '';
    };
    extraPkgs = mkOption {
      default = with pkgs; [ wally-cli ];
      type = types.listOf types.package;
      description = ''
        List of extra packages to install
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = cfg.extraPkgs;
      hardware.keyboard.zsa.enable = true;
      services.xserver.extraConfig = mkIf cfg.ignoreLayoutSettings ''${builtins.readFile "${inputs.dotfiles}/config/xorg/99-moonlander.conf"}'';
    }
  ]);
}
