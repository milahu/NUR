{ config, lib, pkgs, ... }:

let
  inherit (lib) escapeShellArg getExe getExe';
  inherit (pkgs) substitute writeShellScript;
in
{
  imports = [
    ../../common/user.nix
    ./local/user.nix
  ];

  # Nix
  home.stateVersion = "22.05"; # Permanent

  # Host parameters
  host = {
    background = "file://${./resources/background.jpg}";
    cores = 16;
    display_density = 1.75;
    display_width = 3840;
    firefox.profile = "ahrdm58c.default";
    local = ./local;
  };

  # Unfree packages
  allowedUnfree = [
    "attachments"
  ];

  # Display
  xdg.dataFile."icc/ThinkPad-P16s-OLED.icc".source = ./resources/ThinkPad-P16s-OLED.icc;

  # Modules
  programs.watson.enable = true;
  programs.yt-dlp.enable = true;

  # Packages
  home.packages = with pkgs; [
    album-art
    alpaca
    attachments
    audacity
    awscli2
    calibre
    chromium
    decompiler-mc
    digikam
    dino
    email-hash
    fastnbt-tools
    filter-imf
    fontforge-gtk
    gpsprune
    graphviz
    hugin
    jan
    jitsi-meet-electron
    josm
    kdePackages.kdenlive
    libreoffice
    losslesscut-bin
    mark-applier
    mcaselector
    nvtopPackages.amd
    python3Packages.meshtastic
    meshtastic-url
    minemap
    nbt-explorer
    picard
    prismlauncher
    qgis
    rapid-photo-downloader
    signal-desktop
    soundconverter
    thunderbird
    tor-browser-bundle-bin
    transmission_4-gtk
    video-trimmer
    wasistlos
    whipper
    wireguard-vanity-address
    wireshark
  ];
  xdg.dataFile."JOSM/plugins/imagery_used.jar".source = "${pkgs.josm-imagery-used}/share/JOSM/plugins/imagery_used.jar";

  # File type associations
  xdg.mimeApps.defaultApplications = {
    "application/epub+zip" = "calibre-ebook-viewer.desktop";
    "application/x-ptoptimizer-script" = "hugin.desktop";
    "font/otf" = "org.gnome.font-viewer.desktop";
    "font/ttf" = "org.gnome.font-viewer.desktop";
    "x-scheme-handler/mailto" = "firefox.desktop";
  };

  # Password store
  programs.gopass.settings.mounts.path = "${config.home.homeDirectory}/akorg/resource/password-store";

  # Notes
  programs.joplin-desktop.extraConfig = let filesystem = 2 /* enum */; in {
    "sync.target" = filesystem;
    "sync.${toString filesystem}.path" = "${config.home.homeDirectory}/akorg/resource/joplin-sync";
  };

  # GNOME Shell launcher scripts
  launcherScripts = with pkgs; {
    "IMF → filtered IMF" = "kitty ${escapeShellArg (writeShellScript "filter-imf" ''
        ${getExe' wl-clipboard "wl-paste"} --no-newline --type 'text' \
        | CLICOLOR_FORCE='✓' ${getExe filter-imf} \
        | ${getExe' wl-clipboard "wl-copy"} --type 'TEXT'
      '')}";
  };

  # Workaround for dino/dino#299
  xdg.configFile."autostart/im.dino.Dino.desktop".source = substitute {
    src = "${pkgs.dino}/share/applications/im.dino.Dino.desktop";
    substitutions = [ "--replace-fail" "Exec=dino %U" "Exec=dino --gapplication-service" ];
  };

  # Environment
  home.sessionVariables = {
    ATTACHMENTS_ENV = config.home.homeDirectory + "/.attachments.env";
    EMAIL_HASH_DB = config.home.homeDirectory + "/akorg/resource/email-hash/email-hash.db";
  };
}
