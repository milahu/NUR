# usage:
# - start a DM with a rando via
#   - '+' -> 'start conversation'
# - add a user to your roster via
#   - '+' -> 'start conversation' -> '+'  (opens the "add contact" dialog)
#   - this triggers a popup on the remote side asking them for confirmation
#   - after the remote's confirmation there will be a local popup for you to allow them to add you to their roster
# - to make a call:
#   - ensure the other party is in your roster
#   - open a DM with the party
#   - click the phone icon at top (only visible if other party is in your roster)
#
# dino can be autostarted on login -- useful to ensure that i always receive calls and notifications --
# but at present it has no "start in tray" type of option: it must render a window.
#
# outstanding bugs:
# - NAT holepunching burns CPU/NET when multiple interfaces are up
#   - fix by just `ip link set ovpnd-xyz down`
#     - setting `wg-home` down *seems* to be not necessary
#   - characterized by UPnP/SOAP error 500/718 in wireshark
#   - seems it asks router A to open a port mapping for an IP address which belongs to a different subnet...
# - mic is sometimes disabled at call start despite presenting as enabled
#   - fix is to toggle it off -> on in the Dino UI
# - default mic gain is WAY TOO MUCH (heavily distorted)
# - opening pavucontrol during a call causes pipewire to crash, and after pw crash the dino call is permanently mute
# - on lappy/desktop, right-clicking the mic button allows to toggle audio devices, but impossible to trigger this on moby/touch screen!
# - TODO: see if Dino calls work better with `echo full > /sys/kernel/debug/sched/preempt`
#
# probably fixed:
# - once per 1-2 minutes dino will temporarily drop mic input:
#   - `rtp-WRNING: plugin.vala:148: Warning in pipeline: Can't record audio fast enough
#   - this was *partially* fixed by bumping the pipewire mic buffer to 2048 samples (from ~512)
#   - this was further fixed by setting PULSE_LATENCY_MSEC=20.
#   - possibly Dino should be updated internally: `info.rate / 100` -> `info.rate / 50`.
#     - i think that affects the batching for echo cancellation, adaptive gain control, etc.
#   - dino *should* be able to use Pipewire directly for calls instead of going through pulse, but had trouble achieving that in actuality
#
{ config, lib, pkgs, ... }:
let
  cfg = config.sane.programs.dino;
in
{
  sane.programs.dino = {
    configOption = with lib; mkOption {
      default = {};
      type = types.submodule {
        options.autostart = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };

    packageUnwrapped = pkgs.dino.overrideAttrs (upstream: {
      # i'm updating experimentally to see if it improves call performance.
      # i don't *think* this is actually necessary; i don't notice any difference.
      version = "0.4.3-unstable-2024-04-01";
      src = lib.warnIf (lib.versionOlder "0.4.3" upstream.version) "dino update: safe to remove sane patches" pkgs.fetchFromGitHub {
        owner = "dino";
        repo = "dino";
        rev = "d9fa4daa6a7d16f5f0e2183a77ee2d07849dd9f3";
        hash = "sha256-vJBIMsMLlK8Aw19fD2aFNtegXkjOqEgb3m1hi3fE5DE=";
      };
      checkPhase = ''
        runHook preCheck
        ./xmpp-vala-test
        # ./signal-protocol-vala-test  # doesn't exist anymore
        runHook postCheck
      '';
    });

    sandbox.method = "bwrap";
    sandbox.net = "clearnet";
    sandbox.whitelistAudio = true;
    sandbox.whitelistDbus = [ "user" ];  # notifications
    sandbox.whitelistDri = true;  #< not strictly necessary, but we need all the perf we can get on moby
    sandbox.whitelistWayland = true;
    sandbox.extraHomePaths = [
      "Music"
      "Pictures/albums"
      "Pictures/cat"
      "Pictures/from"
      "Pictures/Photos"
      "Pictures/Screenshots"
      "Pictures/servo-macros"
      "Videos/local"
      "Videos/servo"
      "tmp"
    ];

    persist.byStore.private = [ ".local/share/dino" ];

    services.dino = {
      description = "dino XMPP client";
      partOf = lib.mkIf cfg.config.autostart [ "graphical-session" ];

      # audio buffering; see: <https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/FAQ#pipewire-buffering-explained>
      # dino defaults to 10ms mic buffer, which causes underruns, which Dino handles *very* poorly
      # as in, the other end of the call will just not receive sound from us for a couple seconds.
      # pipewire uses power-of-two buffering for the mic itself (by default), but this env var supports only whole numbers, which isn't quite reconcilable:
      # - 1024/48000 = 21.33ms
      # - 2048/48000 = 42.67ms
      # - 4096/48000 = 85.33ms
      # also, Dino's likely still doing things in 10ms batches internally.
      #
      # note that this number supposedly is just the buffer size which Dino asks Pulse (pipewire) to share with it.
      # in theory, it's equivalent to adjusting pipewire's quanta setting, and so isn't additive to the existing pipewire buffers.
      # (and would also be overriden by pipewire's quanta.min setting).
      # but in practice, setting this seems to have some more effect beyond just the buffer sizes visible in `pw-top`.
      #
      # further: decrease the "niceness" of dino, so that it can take precedence over anything else.
      # ideally this would target just the audio processing, rather than the whole program.
      # pipewire is the equivalent of `nice -n -21`, so probably don't want to go any more extreme than that.
      # nice -n -15 chosen arbitrarily; not optimized (and seems to have very little impact in practice anyway).
      # buffer size:
      # - 1024 (PULSE_LATENCY_MSEC=20): `pw-top` shows several underruns per second.
      # - 2048 (PULSE_LATENCY_MSEC=40): `pw-top` shows very few underruns. maybe 1-2 per minute. but i still get gaps in which the mic "disappears"
      # - 4096 (PULSE_LATENCY_MSEC=100): `pw-top` shows 0 underruns.
      #
      # note that debug logging during calls produces so much journal spam that it pegs the CPU and causes dropped audio
      # env G_MESSAGES_DEBUG = "all";
      command = "env PULSE_LATENCY_MSEC=100 nice -n -15 dino";
    };
  };
}
