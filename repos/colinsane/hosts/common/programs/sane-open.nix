{ ... }:
{
  sane.programs.sane-open = {
    sandbox.method = "bwrap";
    sandbox.autodetectCliPaths = "existing";  # for when opening a file
    sandbox.whitelistDbus = [ "user" ];
    sandbox.extraConfig = [
      "--sane-sandbox-keep-namespace" "pid"  # to toggle keyboard
    ];
    sandbox.extraHomePaths = [
      ".local/share/applications"
    ];
    sandbox.extraRuntimePaths = [ "sway" ];
    suggestedPrograms = [
      "gdbus"
      "xdg-utils"
    ];

    mime.associations."application/x-desktop" = "sane-open-desktop.desktop";
  };
}
