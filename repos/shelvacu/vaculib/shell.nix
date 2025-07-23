{ lib, pkgs, ... }:
{
  # https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
  shellColors = {
    black = 30;
    red = 31;
    green = 32;
    yellow = 33;
    blue = 34;
    magenta = 35;
    cyan = 36;
    white = 37;
  };
  script =
    name: content:
    pkgs.writers.makeScriptWriter
      {
        interpreter = lib.getExe pkgs.bashInteractive;
        check = lib.escapeShellArgs [
          (lib.getExe pkgs.shellcheck)
          "--norc"
          "--severity=info"
          "--exclude=SC2016"
          pkgs.shellvaculib.file
        ];
      }
      "/bin/${name}"
      ''
        source ${lib.escapeShellArg pkgs.shellvaculib.file}
        ${content}
      '';
}
