{ pkgs, ... }:
{
  sane.programs.sane-battery-estimate = {
    packageUnwrapped = pkgs.static-nix-shell.mkBash {
      pname = "sane-battery-estimate";
      srcRoot = ./.;
    };
    sandbox.method = "bwrap";
    sandbox.extraPaths = [
      "/sys/class/power_supply"
      "/sys/devices"
    ];
  };

  sane.programs.conky = {
    sandbox.method = "bwrap";
    sandbox.net = "clearnet";  #< for the scripts it calls (weather)
    sandbox.extraPaths = [
      "/sys/class/power_supply"
      "/sys/devices"  # needed by battery_estimate
      # "/sys/devices/cpu"
      # "/sys/devices/system"
    ];
    sandbox.whitelistWayland = true;

    suggestedPrograms = [
      "sane-battery-estimate"
      "sane-weather"
    ];

    fs.".config/conky/conky.conf".symlink.target = pkgs.substituteAll {
      src = ./conky.conf;
      bat = "sane-battery-estimate";
      weather = "timeout 20 sane-weather";
    };

    services.conky = {
      description = "conky dynamic desktop background";
      partOf = [ "graphical-session" ];
      command = "conky";
    };
  };
}
