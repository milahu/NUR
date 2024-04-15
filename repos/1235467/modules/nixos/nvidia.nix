{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.nvk;
in
{
  options.nvk = {
  enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Select which NVIDIA driver to use

            Possible values:
            `false`: Official driver, a bit buggy.
            `true`: Open source driver, under heavy development, unstable.
        '';
      };
  };
  config.boot.kernelParams = if cfg.enable then [
"nouveau.config=NvGspRm=1" 
"nouveau.debug=info,VBIOS=info,gsp=debug"
] else [];
  config.services.xserver.videoDrivers = if cfg.enable then ["nouveau"] else ["nvidia"];
  config.chaotic.mesa-git.enable = if cfg.enable then lib.mkForce true else lib.mkForce false;
  config.chaotic.mesa-git.fallbackSpecialisation = false;
}

