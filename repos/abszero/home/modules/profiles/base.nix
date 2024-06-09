{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) const;
in

{
  # FIXME: Still broken, needs --impure to build
  nixpkgs.config.allowUnfreePredicate = const true;

  home = {
    stateVersion = "24.11";
    # Print store diff using nvd
    activation.diff = config.lib.dag.entryBefore [ "writeBoundary" ] ''
      if [[ -v oldGenPath ]]; then
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      fi
    '';
  };

  xdg.enable = true;

  programs.home-manager.enable = true;
}
