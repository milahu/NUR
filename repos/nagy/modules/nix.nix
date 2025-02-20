{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nil

    nix-prefetch
    # nix-prefetch-git # creates spooky temporary files during fetch.
    nix-diff
    nvd
    # nix-du
    nix-tree
    nix-init
    nix-update
    nix-output-monitor
    # nix-eval-jobs

    nickel
    nls
  ];
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "recursive-nix"
        "impure-derivations"
        "ca-derivations"
      ];
      sandbox = true;
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      warn-dirty = false;
      # eval-cache = false;
      # Build logs are backed up. Backup mechanism itself takes care of the compression already.
      compress-build-log = false;
      # this reduces memory usage at the expense of performance
      # cores = 1;
      # this keeps build logs clean at the expense of performance
      # max-jobs = 1;
    };
  };
}
