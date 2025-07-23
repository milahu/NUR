{ ... }:
{
  imports = [ ../common/home.nix ];
  home.stateVersion = "24.05";
  home.homeDirectory = "/data/data/com.termux.nix/files/home";
  home.username = "nix-on-droid";
}
