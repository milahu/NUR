{ ... }:
{
  sane.programs.xdg-open = {
    sandbox.autodetectCliPaths = "existing";
    # XXX(2026-01-14): xdg-open only requires the OpenURI xdp portal,
    # but since sandboxed programs call xdg-open, and xdg-dbus-proxy doesn't support nesting,
    # we have to pass through the entire dbus session.
    sandbox.whitelistDbus.user.all = true;
    # sandbox.whitelistPortal = [
    #   "OpenURI"
    # ];

    # env.NIXOS_XDG_OPEN_USE_PORTAL = "1";  #< required for `xdg-utils`; but for `flatpak-xdg-utils` this is default
  };
}
