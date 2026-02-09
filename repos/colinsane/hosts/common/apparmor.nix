{ config, lib, pkgs, ... }:
{
  security.apparmor.enable = lib.mkDefault true;
  # security.apparmor.killUnconfinedConfinables = true;

  environment.systemPackages = [
    # for `man 5 apparmor.d`
    pkgs.apparmor-parser
  ];

  # security.pam.services.sudo.enableAppArmor = true;
  # # security.pam.services.sshd.enableAppArmor = true;
  # security.pam.services.login.enableAppArmor = true;

  security.apparmor.policies."bin.ping".profile = ''
    include "${pkgs.iputils.apparmor}/bin.ping"
  '';
  # security.apparmor.includes."local/bin.ping" = "";

  # abstractions/nameservice includes abstractions/nss-systemd.
  # nss-systemd needs to invoke:
  # - libnss_mymachines.so (a.k.a "mymachines" in /etc/nsswitch.conf)
  # - libnss_myhostname.so (a.k.a "myhostname" in /etc/nsswitch.conf)
  #   -> reads /proc/sys/net/ipv6/conf/all/disable_ipv6 to decide whether to return IPv6 response (socket_ipv6_is_enabled)
  #      see with e.g. `ping $(hostname).`
  #      trailing . ensures it's not resolved by /etc/hosts; make sure to disable avahi-daemon else it'll be fielded by $(hostname).local.
  security.apparmor.includes."abstractions/nss-systemd" = ''
    include "${
      pkgs.apparmorRulesFromClosure { name = "systemd"; } (
        [ pkgs.systemd ]
      )
    }"
  '';

  # abstractions/nameservice includes:
  # > # avahi-daemon is used for mdns4 resolution
  # > @{run}/avahi-daemon/socket rw,
  # it's specifically "mdns" and "mdns_minimal" (i.e. pkgs.nssmdns) in /etc/nsswitch.conf which query /run/avahi-daemon/socket over AF_UNIX.
  # N.B.: there's also `abstractions/mdns`, included by `abstractions/nameserver`.
  #   that seems to only be used for `mdnsd`, for unknown reasons.
  #
  # TODO: upstream this by just including _all_ of `config.system.nssModules.list` in the apparmor closure?
  security.apparmor.includes."abstractions/nameservice" = lib.mkIf (lib.elem pkgs.nssmdns config.system.nssModules.list) ''
    include "${
      pkgs.apparmorRulesFromClosure { name = "nssmdns"; } (
        [ pkgs.nssmdns ]
      )
    }"
  '';

  # N.B.: nsswitch.conf `passwd` database will require tcb
}
