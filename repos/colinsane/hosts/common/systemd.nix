{ ... }:
let
  # N.B.: systemd doesn't like to honor its timeout settings.
  # a timeout of 20s is actually closer to 70s,
  # because it allows 20s, then after the 20s passes decides to allow 40s, then 60s,
  # finally it peacefully kills stuff, and then 10s later actually kills shit.
  haltTimeout = 10;
in
{
  # allow ordinary users to `reboot` or `shutdown`.
  # source: <https://nixos.wiki/wiki/Polkit>
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  services.journald.extraConfig = ''
    # docs: `man journald.conf`
    # merged journald config is deployed to /etc/systemd/journald.conf
    [Journal]
    # disable journal compression because the underlying fs is compressed
    Compress=no
  '';

  # see: `man logind.conf`
  # don’t shutdown when power button is short-pressed (commonly done an accident, or by cats).
  #   but do on long-press: useful to gracefully power-off server.
  services.logind.powerKey = "lock";
  services.logind.powerKeyLongPress = "poweroff";
  services.logind.lidSwitch = "lock";

  systemd.extraConfig = ''
    # DefaultTimeoutStopSec defaults to 90s, and frequently blocks overall system shutdown.
    DefaultTimeoutStopSec=${builtins.toString haltTimeout}
  '';
}
