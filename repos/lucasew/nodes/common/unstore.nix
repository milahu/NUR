{config, lib, pkgs, ...}:
let
  inherit (lib) types mkEnableOption mkOption mkIf;
  cfg = config.services.unstore;
  inherit (builtins) concatStringsSep replaceStrings;
in {
  options.services.unstore = {
    enable = mkEnableOption "unstore: scheduled delete of nix-store paths that contain a file pattern";
    paths = mkOption {
      description = "Path patterns to remove";
      type = types.listOf lib.types.str;
      default = [ "job_runner.ipynb" "flake.nix" ];
    };
    startAt = mkOption {
      description = "When to run the service";
      type = types.str;
      default = "*-*-* *:00:00";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.unstore = {
      inherit (cfg) enable startAt;
      path = with pkgs; [ nix coreutils fd ];
      description = "delete paths that contain a file pattern in the nix-store";
      script = let
        paths = concatStringsSep " " (map (item: ''"${item}"'') cfg.paths);
      in ''
        if [ $(cat /sys/class/power_supply/ACAD/online) == 0 ]; then
          echo "On battery, skipping..."
          exit 0
        fi
        for p in ${paths} ; do
          fd -d 2 "$p" /nix/store | while read item; do
            if [ -z "$(nice -20 nix-store --query --requisites "$item")" ]; then
              echo $item
              # nice -20 nix-store --delete "$item"
            else
              true
              # echo "Not removing '$item'" >&2
            fi
          done
        done | uniq
      '';
    };
  };
}
