{ config, pkgs, ... }:

let
  system = import <nixpkgs/nixos> { };
in
{
  imports = [
    ../../user.nix
    ./user.local.nix
  ];

  # Nix
  home.stateVersion = "24.11"; # Permanent

  # System configuration
  system = system.config;

  # Host parameters
  host = {
    dir = ./.;
    firefox.profile = "gpihihlj.default";
  };

  # Modules
  programs.yt-dlp.enable = true;

  # Packages
  home.packages = with pkgs; [
    awscli2
    chromium
    email-hash
    josm
    libreoffice
    mark-applier
    tor-browser
    transmission_4-gtk
  ];
  xdg.dataFile."JOSM/plugins/imagery_used.jar".source = "${pkgs.josm-imagery-used}/share/JOSM/plugins/imagery_used.jar";

  # File type associations
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/mailto" = "firefox.desktop";
  };

  # Password store
  programs.gopass.settings.mounts.path = "${config.home.homeDirectory}/akorg/resource/password-store";

  # Notes
  programs.joplin-desktop.extraConfig = let filesystem = 2 /* enum */; in {
    "sync.target" = filesystem;
    "sync.${toString filesystem}.path" = "${config.home.homeDirectory}/akorg/resource/joplin-sync";
  };

  # Environment
  home.sessionVariables = {
    EMAIL_HASH_DB = config.home.homeDirectory + "/akorg/resource/email-hash/email-hash.db";
  };
}
