{ pkgs, ... }:
{
  sane.programs.tor-browser = {
    packageUnwrapped = pkgs.tor-browser.overrideAttrs (upstream: {
      # add `--allow-remote` flag so that i can do `tor-browser http://...` to open in an existing instance.
      preBuild = (upstream.preBuild or "") + ''
        makeWrapper() {
          makeShellWrapper "$@" --add-flags --allow-remote
        }
      '';
    });
    sandbox.method = "bwrap";
    sandbox.wrapperType = "inplace";  # trivial package, so cheaper to wrap in-place
    sandbox.net = "clearnet";  # tor over VPN wouldn't make sense
    sandbox.whitelistAudio = true;
    sandbox.whitelistDbus = [ "user" ];  #< so `tor-browser http://...` can open using an existing instance
    sandbox.whitelistWayland = true;
    persist.byStore.ephemeral = [
      ".local/share/tor-browser"
    ];
    mime.urlAssociations."^https?://.+\.onion$" = "torbrowser.desktop";
  };
}
