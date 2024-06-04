{ pkgs, ... }:
{
  sane.programs.mmcli = {
    packageUnwrapped = pkgs.modemmanager-split.mmcli.overrideAttrs (upstream: {
      meta = upstream.meta // {
        mainProgram = "mmcli";
      };
    });
    # TODO: sandbox
  };
}

