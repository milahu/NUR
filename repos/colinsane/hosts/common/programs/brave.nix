{ ... }:
{
  sane.programs.brave = {
    sandbox.method = "bwrap";
    sandbox.wrapperType = "inplace";  # /opt/share/brave.com vendor-style packaging
    sandbox.net = "all";
    sandbox.extraHomePaths = [
      "dev"  # for developing anything web-related
      "tmp"
    ];
    sandbox.extraPaths = [
      "/tmp"  # needed particularly if run from `sane-vpn do`
    ];
    sandbox.whitelistAudio = true;
    sandbox.whitelistDri = true;
    sandbox.whitelistWayland = true;

    persist.byStore.cryptClearOnBoot = [
      ".cache/BraveSoftware"
      ".config/BraveSoftware"
    ];
  };
}
