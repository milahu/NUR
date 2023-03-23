{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mpdscribble;

  toMpdscribbleIni = c:
    let
      mkKeyValue = key: value:
        let
          quoted = v:
            if hasPrefix " " v || hasSuffix " " v then ''"${v}"'' else v;

          value' = if isString value then quoted value else toString value;

        in if isNull value then "" else "${key}=${value'}";

      global = concatStringsSep "\n"
        (mapAttrsToList mkKeyValue (filterAttrs (k: v: !isAttrs v) c));

      sections = generators.toINI { inherit mkKeyValue; }
        (filterAttrs (k: v: isAttrs v) c);
    in global + "\n\n" + sections;

in {
  options = {
    services.mpdscribble = {
      enable = mkEnableOption "Whether to enable mpdscribble.";

      package = mkOption {
        type = with types; package;
        default = pkgs.mpdscribble;
        description = "Package to use for mpdscribble.";
      };

      config = mkOption {
        type = with types;
          let value = oneOf [ str int bool path (listOf str) ];
          in attrsOf (either value (attrsOf value));
        default = { };
        example = {
          host = "localhost";
          port = 6600;
          verbose = 2;

          "libre.fm" = {
            url = "https://turtle.libre.fm/";
            username = "myUsername";
            password = "myPassword";
          };
        };
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration that will be appended to the end.";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."mpdscribble/mpdscribble.conf".text =
      (toMpdscribbleIni cfg.config + "\n" + cfg.extraConfig);

    systemd.user.services.mpdscribble = {
      Unit = {
        Description = "mpdscribble server";
        After = [ "networking.target" ];
      };

      Install = { WantedBy = [ "default.target" ]; };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/mpdscribble --conf ${
            config.xdg.configFile."mpdscribble/mpdscribble.conf".source
          } --no-daemon";
        Restart = "on-failure";
      };
    };
  };
}
