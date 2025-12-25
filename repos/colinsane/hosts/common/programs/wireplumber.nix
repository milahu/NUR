{ config, pkgs, ... }:
{
  sane.programs.wireplumber = {
    packageUnwrapped = pkgs.wireplumber.override {
      # use the same pipewire as configured to run against.
      pipewire = config.sane.programs.pipewire.packageUnwrapped;
    };

    sandbox.whitelistDbus.user = true;  #< required for camera sharing, especially through xdg-desktop-portal, e.g. `snapshot` application  (TODO: reduce)
    sandbox.whitelistDbus.system = true;  #< required to handshake with bluetooth audio devices. also grants access to rtkit (optional integration; not much lost if omitted)
    sandbox.whitelistAudio = true;
    sandbox.whitelistAvDev = true;
    # sandbox.keepPids = true;  #< needed if i want rtkit to grant this higher scheduling priority
    # sandbox.net = "all";  #< needed if you want to plug audio devices at runtime (udev; AF_NETLINK)

    sandbox.extraHomePaths = [
      ".config/wireplumber"
    ];

    suggestedPrograms = [ "alsa-ucm-conf" ];

    persist.byStore.plaintext = [
      # persist per-device volume levels, device <-> client links, etc.
      # files:
      # - default-nodes:
      #   - ranked preferences for which device to make the default audio sink/source.
      # - stream-properties:
      #   - per-application volume & mute states
      # - default-routes:
      #   - soundcard volume & mute states
      # - default-profile:
      #   - default soundcard?
      ".local/state/wireplumber"
    ];

    fs.".config/wireplumber/wireplumber.conf.d/10-sane-config.conf".symlink.text = ''
      wireplumber.settings = {
        device.restore-profile = false
        # persist device volume/mute/codec switches
        device.restore-routes = true
        # persist system default source/sink: true/false
        node.restore-default-targets = false
        # persist app volume/mute settings: true/false
        node.stream.restore-props = false
        # persist app input/output links: true/false
        node.stream.restore-target = false
      }

      # log spec is "[<topic>:]level,...,"
      # where `level` is
      # - `0` or `F`: fatal errors
      # - `1` or `E`: critical warnings
      # - `2` or `W` or `N`: warnings and notices
      # - `3` or `I`: informational messages
      # - `4` or `D`: debug messages
      # - `5` or `T`: trace messages
      # context.properties = {
      #   log.level = "D"
      # }
    '';

    services.wireplumber = {
      description = "wireplumber: pipewire Multimedia Service Session Manager";
      depends = [ "pipewire" ];
      partOf = [ "sound" ];
      command = "wireplumber";
    };
  };
}
