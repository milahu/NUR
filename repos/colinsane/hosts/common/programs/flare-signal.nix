# Flare is a 3rd-party GTK4 Signal app.
# UI is effectively a clone of Fractal.
#
### compatibility:
# - desko: works fine. pairs, and exchanges contact list (but not message history) with the paired device. exchanges future messages fine.
# - moby (cross compiled flare-signal-nixified): nope. it pairs, but can only *receive* messages and never *send* them.
#   - even `rsync`ing the data and keyrings from desko -> moby, still fails in that same manner.
#   - console shows error messages. quite possibly an endianness mismatch somewhere
# - moby (partially-emulated flare-signal): works! pairs and can send/receive messages, same as desko.
#
### debugging:
# - `RUST_LOG=flare=trace flare`
#
### error signatures (to reset, run `sane-wipe flare`):
#### upon sending a message, the other side receives it, but Signal desktop gets "A message from Colin could not be delivered" and the local CLI shows:
#   ```
#   ERROR libsignal_service::websocket] SignalWebSocket: Websocket error: SignalWebSocket: end of application request stream; socket closing
#   ERROR presage::manager] Error opening envelope: ProtobufDecodeError(DecodeError { description: "invalid tag value: 0", stack: [("Content", "data_message")] }), message will be skipped!
#   ERROR presage::manager] Error opening envelope: ProtobufDecodeError(DecodeError { description: "invalid tag value: 0", stack: [("Content", "data_message")] }), message will be skipped!
#   ```
# - this occurs on moby, desko, `flare-signal` and `flare-signal-nixified`
# - the Websocket error seems to be unrelated, occurs during normal/good operation
# - related issues: <https://github.com/whisperfish/presage/issues/152>
#
#### error when sending from Flare to other Flare device:
# - ```
#   ERROR libsignal_protocol::session_cipher] Message from <UUID>.3 failed to decrypt; sender ratchet public key <key> message counter 1
#       No current session
#   ERROR presage::manager] Error opening envelope: SignalProtocolError(InvalidKyberPreKeyId), message will be skipped!
#   ```
# - but signal iOS will still read it.
#
#### HTTP 405 when linking flare to iOS signal:
# [DEBUG libsignal_service_hyper::push_service] HTTP request PUT https://chat.signal.org/v1/devices/{uuid}.{timestamp?}:{b64-string}
# [TRACE libsignal_service_hyper::push_service] Unhandled response 405 with body: {"code":405,"message":"HTTP 405 Method Not Allowed"}
# [ERROR flare::gui::error_dialog] ErrorDialog displaying error: Something unexpected happened with the signal backend. Please retry later.
# [TRACE flare::gui::error_dialog] ErrorDialog full error: Presage(
#         ProvisioningError(
#             ServiceError(
#                 UnhandledResponseCode {
#                     http_code: 405,
#                 },
#             ),
#         ),
#     )
# flare matrix suggests the signal endpoint has changed:
# - "/v1/device/link instead of confirming via /v1/devices/{I'd}"
# - this endpoint is declared in libsignal-service-rs (used both by flare and presage)
#   - libsignal-service/src/provisioning/manager.rs
#   - libsignal-service issues a put_json to that URL (i.e. HTTP PUT)
# - libsignal-service is "based on" the official rust signal API <https://github.com/signalapp/libsignal>
#   - did these guys recently change it?
#   - no, but Signal-Desktop did. see ccb5eb0dd2 from 2023/08/29
#     - that's a fairly involved change.
# - signalcli is reporting this same error: <https://github.com/AsamK/signal-cli/issues/1399>
# - Mixin Messenger / libsignal_protocol_dart doesn't seem to be reporting any issue
#   - <https://github.com/MixinNetwork/flutter-app>
#
# well, seems to have unpredictable errors particularly when being used on multiple devices.
# desktop _seems_ more reliable than on mobile, but not confident.

{ pkgs, ... }:
{
  sane.programs.flare-signal = {
    packageUnwrapped = pkgs.flare-signal-nixified;
    # packageUnwrapped = pkgs.flare-signal;
    persist.byStore.private = [
      # everything: conf, state, files, all opaque
      ".local/share/flare"
      # also persists a secret in ~/.local/share/keyrings. reset with:
      # - `secret-tool search --all --unlock 'xdg:schema' 'de.schmidhuberj.Flare'`
      # - `secret-tool clear 'xdg:schema' 'de.schmidhuberj.Flare'`
      # and it persists some dconf settings (e.g. device name). reset with:
      # - `dconf reset -f /de/schmidhuberj/Flare/`.
    ];
  };
}
