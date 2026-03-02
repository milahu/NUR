{ config, lib, ... }:

let
  inherit (builtins) attrNames length;
  inherit (config.services) unison;
  inherit (lib) mapAttrs' mkForce mkIf mkOption nameValuePair;
  inherit (lib.types) attrsOf nullOr str submodule;

  mkUnits = f: mapAttrs'
    (n: p: nameValuePair "unison-pair-${n}" (mkIf (p.when != null) (f p)))
    unison.pairs;
in
{
  options = {
    services.unison.pairs = mkOption {
      type = attrsOf (submodule {
        options = {
          when = mkOption { type = nullOr str; default = null; };
        };
      });
    };
  };

  config = {
    services.unison.enable = length (attrNames unison.pairs) > 0;

    systemd.user.services = mkUnits (pair: {
      Service.CPUSchedulingPolicy = mkForce "batch";
      Service.IOSchedulingClass = mkForce "best-effort";
    });

    systemd.user.timers = mkUnits (pair: {
      Install.WantedBy = mkForce [ pair.when ];
      Unit.StopWhenUnneeded = true;
    });
  };
}
