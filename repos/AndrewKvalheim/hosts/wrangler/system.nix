{ ... }:

{
  imports = [
    ../../system.nix
    <nixos-hardware/lenovo/thinkpad/t14/amd/gen2>
    /etc/nixos/hardware-configuration.nix
    ./system.local.nix
  ];

  # Host parameters
  host = {
    dir = ./.;
    name = "wrangler";
  };

  # Hardware
  services.kmonad.keyboards.default.device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  # Nix
  system.stateVersion = "22.05"; # Permanent

  # Mouse
  services.input-remapper.enable = true;

  # Networking
  systemd.network.links = {
    "10-wifi".linkConfig.Name = "wifi";
  };
}
