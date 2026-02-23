{ config, lib, ... }:

let
  inherit (builtins) attrNames length;
  inherit (config.services) unison;
  inherit (lib) mapAttrs' mkForce mkIf mkOption nameValuePair;
  inherit (lib.types) attrsOf nullOr str submodule;
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

    systemd.user.timers = mapAttrs'
      (n: p: nameValuePair "unison-pair-${n}" (mkIf (p.when != null) {
        Install.WantedBy = mkForce [ p.when ];
        Unit.StopWhenUnneeded = true;
      }))
      unison.pairs;
  };
}
