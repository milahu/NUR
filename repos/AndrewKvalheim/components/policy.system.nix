{ config, lib, ... }:

let
  inherit (config.security.sudo) allowedCommands;
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in
{
  options = {
    security.sudo.allowedCommands = mkOption { type = listOf str; default = [ ]; };
  };

  config = {
    security.sudo.extraRules = [{
      groups = [ "wheel" ];
      commands = map (c: { command = c; options = [ "NOPASSWD" ]; }) allowedCommands;
    }];
  };
}
