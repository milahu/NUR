{ lib, pkgs, ... }:

let
  inherit (lib) getExe;

  identity = import ../library/identity.lib.nix { inherit lib; };
in
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  systemd.user.services.yubikey-touch-detector = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit.PartOf = [ "graphical-session.target" ];
    Unit.Description = "YubiKey touch detector";
    Service.ExecStart = "${getExe pkgs.yubikey-touch-detector} --libnotify";
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = identity.openpgp.id;
      keyid-format = "0xlong";
      no-greeting = true;
      no-symkey-cache = true;
      throw-keyids = true;
    };
    # Workaround for “gpg-agent: scdaemon: ccid open error: skip”
    scdaemonSettings.disable-ccid = true;
  };
}
