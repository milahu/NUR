{ config, lib, pkgs, ... }:

let
  inherit (config.programs) ccache;
  inherit (lib) escapeShellArg getExe makeBinPath;

  nur = import ../../nur.nix { inherit pkgs; };
in
{
  imports = [ nur.modules.nixpkgs-issue-55674 ];

  config = {
    # Daemon
    nix.daemonCPUSchedPolicy = "batch";
    nix.daemonIOSchedClass = "idle";

    # Users
    nix.settings.trusted-users = [ "@wheel" ];

    # Storage
    nix.settings.auto-optimise-store = true;
    nix.gc = { automatic = true; options = "--delete-older-than 7d"; };
    nix.extraOptions = ''
      # Recommended by nix-direnv
      keep-outputs = true
      keep-derivations = true
    '';

    # Binary cache
    nix.settings.trusted-public-keys = [
      "satellite:1IPrFEVB4K6/5Tokjv7lgvlxtxY2ZvL0t9Iy6ts5W4c="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    nix.settings.substituters = [
      "ssh://nix-ssh@satellite?compress=true"
      "https://nix-community.cachix.org"
    ];
    nix.settings.fallback = true;

    # Compile cache
    programs.ccache.enable = true;
    nix.settings.extra-sandbox-paths = [ ccache.cacheDir ];

    # Distributed build
    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;
    nix.buildMachines = [{
      hostName = "satellite";
      sshUser = "nix-ssh";
      system = "x86_64-linux";
      supportedFeatures = [ "big-parallel" "kvm" "nixos-test" ];
    }];

    # Validation
    # TODO: systemd.enableStrictShellChecks = true;

    # Diff after rebuild (pending NixOS/nixpkgs#208902)
    system.activationScripts.diff = ''
      PATH="${makeBinPath [ pkgs.nix ]}" \
        ${getExe pkgs.nvd} diff '/run/current-system' "$systemConfig"
    '';

    # Escape hatch
    programs.nix-ld.enable = true;

    nixpkgs.overlays = [
      # Custom packages
      (import ../packages.nix)

      # Build cache
      (_: prev: {
        ccacheWrapper = prev.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS='1'
            export CCACHE_DIR=${escapeShellArg ccache.cacheDir}
            export CCACHE_FILECLONE='1'
            export CCACHE_SLOPPINESS='random_seed' # NixOS/nixpkgs#109033
            export CCACHE_UMASK='007'
          '';
        };
      })
    ];
  };
}
