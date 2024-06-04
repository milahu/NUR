{ pkgs, ... }:
{
  sane.programs.nmcli = {
    packageUnwrapped = pkgs.networkmanager-split.nmcli;
    # TODO: sandbox
  };
}
