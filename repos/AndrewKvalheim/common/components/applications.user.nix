{ config, lib, pkgs, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (config) host;
  inherit (lib) foldlAttrs getExe getExe' imap0 mkOption nameValuePair;
  inherit (lib.generators) toINI toKeyValue;
  inherit (lib.hm.gvariant) mkTuple mkUint32;
  inherit (pkgs) formats onlyBin;
  inherit (pkgs.writers) writeTOML;

  palette = import ../resources/palette.nix { inherit lib pkgs; };
in
{
  imports = [
    ../../packages/nautilus-scripts.nix
    ../../packages/organize-downloads.nix
  ];

  options = {
    programs.gopass.settings = mkOption { type = (formats.ini { }).type; default = { }; };
  };

  config = {
    # Unfree packages
    allowedUnfree = [
      "vagrant"
    ];

    # Associations
    xdg.mimeApps = {
      enable = true;
      defaultApplications = foldlAttrs (byType: handler: types: byType // (listToAttrs (map (type: nameValuePair type handler) types))) { } {
        "audacious.desktop" = [ "audio/x-opus+ogg" ];
        "codium.desktop" = [ "application/gpx+xml" "application/json" "application/rss+xml" "application/x-shellscript" "application/xml" "message/rfc822" "text/markdown" "text/plain" ];
        "firefox.desktop" = [ "application/xhtml+xml" "text/html" "x-scheme-handler/http" "x-scheme-handler/https" ];
        "org.gnome.Evince.desktop" = [ "application/pdf" ];
        "org.gnome.FileRoller.desktop" = [ "application/zip" ];
        "org.gnome.Loupe.desktop" = [ "image/avif" "image/bmp" "image/gif" "image/heif" "image/jpeg" "image/png" "image/svg+xml" "image/tiff" "image/webp" ];
        "org.gnome.Totem.desktop" = [ "video/mp4" "video/mp2t" "video/vnd.avi" "video/webm" "video/x-matroska" ];
        "writer.desktop" = [ "application/vnd.oasis.opendocument.text" "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ];
      };
    };
    xdg.configFile."mimeapps.list".force = true; # Workaround for nix-community/home-manager#1213

    # Modules
    programs.fastfetch.enable = true;
    programs.fd.enable = true;
    programs.gopass.settings = {
      core.autosync = false;
      edit.auto-create = true;
    };
    programs.joplin-desktop = {
      enable = true;
      extraConfig = {
        "locale" = "en_US";
        "dateFormat" = "YYYY-MM-DD";
        "timeFormat" = "HH:mm";
        "export.pdfPageSize" = "Letter";
        "showTrayIcon" = true;
        "style.editor.fontFamily" = "Iosevka Custom Proportional";
        "style.editor.monospaceFontFamily" = "Iosevka Custom Mono";
        "editor.spellcheckBeta" = true; # laurent22/joplin#6453
      };
    };
    programs.jq.enable = true;
    programs.numbat = {
      enable = true;
      settings = {
        exchange-rates.fetching-policy = "on-first-use";
        intro-banner = "off";
        prompt = "❯ ";
      };
    };
    programs.ripgrep.enable = true;
    programs.ssh = {
      enable = true;
      includes = [ "config.d/*" ];
      extraOptionOverrides.PreferredAuthentications = "publickey";
    };
    programs.visidata = {
      enable = true;
      visidatarc = with pkgs; toKeyValue { } {
        "options.clipboard_copy_cmd" = getExe' wl-clipboard "wl-copy";
        "options.clipboard_paste_cmd" = "${getExe' wl-clipboard "wl-paste"} --no-newline";
      };
    };

    # Packages
    home.packages = with pkgs; [
      add-words
      bacon
      binsider
      bubblewrap # Required by nixpkgs-review --sandbox
      bustle
      cavif
      cargo-msrv
      darktable
      dconf-editor
      dig
      displaycal
      dive
      dua
      duperemove
      efficient-compression-tool
      exiftool
      eyedropper
      fast-cli
      ffmpeg
      file
      fq
      gifsicle
      gimp3-with-plugins
      gnome-decoder
      gopass
      gopass-env
      gopass-ydotool
      gucharmap
      guetzli
      guvcview
      htop
      hydra-check
      identity
      ijq
      imagemagickBig
      img2pdf
      (inkscape-with-extensions.override { inkscapeExtensions = with inkscape-extensions; [ applytransforms ]; })
      ipcalc
      iperf
      isd
      jless
      just
      just-local
      killall
      (onlyBin libwebp) # cwebp
      lsof
      magic-wormhole
      miller
      moreutils
      mozjpeg-simple
      mtr
      multitail
      nix-preview
      nix-top
      nix-tree
      nixpkgs-review
      nom-wrappers
      off
      kdePackages.okular
      pdfarranger
      popsicle
      pngquant
      pngtools
      poppler_utils # pdfinfo
      pup
      pwgen
      pwvucontrol
      qalculate-gtk
      rsync
      s-tui
      sqlitebrowser
      step-cli
      nodePackages.svgo
      trash-cli
      uniscribe
      unln
      usbutils
      v4l-utils
      vagrant
      vivictpp
      watchlog
      wev
      whois
      wireguard-tools
      wl-clipboard
      xan
      xh
      xkcdpass
      xorg.xev
      yq
    ];

    # Nautilus scripts
    nautilusScripts = with pkgs; {
      "HEIF,PNG,TIFF → JPEG".xargs = "-n 1 -P 8 nice ${getExe mozjpeg-simple}";
      "JPEG: Strip geolocation".xargs = "nice ${getExe exiftool} -overwrite_original -gps:all= -xmp:geotag=";
      "PNG: Optimize".xargs = ''
        nice ${getExe efficient-compression-tool} -8 -keep -quiet --mt-file \
        2> >(${getExe zenity} --width 600 --progress --pulsate --auto-close --auto-kill)
      '';
      "PNG: Quantize".each = ''
        ${getExe pngquant-interactive} --suffix '.qnt' "$path"
        nice ${getExe efficient-compression-tool} -8 -keep -quiet "''${path%.png}.qnt.png"
      '';
      "PNG: Trim".xargs = "-n 1 -P 8 nice ${getExe' imagemagick "mogrify"} -trim";
    };

    # GNOME Shell launcher scripts
    launcherScripts = with pkgs; {
      "issue reference → GitHub URL" = ''
        if result="$(
          ${getExe' wl-clipboard "wl-paste"} --no-newline --type 'text' \
          | sed --regexp-extended --quiet '\@^(.+)#(.+)$@{s@@https://github.com/\1/issues/\2@p;q};q1'
        )"; then
          ${getExe' wl-clipboard "wl-copy"} --type 'TEXT' "$result"
          ${getExe' libnotify "notify-send"} --icon 'edit-copy-symbolic' --transient 'Updated clipboard' "$result"
        else
          ${getExe' libnotify "notify-send"} --icon 'dialog-error-symbolic' --transient 'Failed to updated clipboard' 'Not an issue reference'
        fi
      '';
      "issue URL → markdown link" = ''
        if result="$(
          ${getExe' wl-clipboard "wl-paste"} --no-newline --type 'text' \
          | sed --regexp-extended --quiet '\@^(https://[^/]+/([^/]+/[^/]+)/(issues|pull)/([[:digit:]]+))$@{s//[\2#\4](\1)/p;q};q1'
        )"; then
          ${getExe' wl-clipboard "wl-copy"} --type 'TEXT' "$result"
          ${getExe' libnotify "notify-send"} --icon 'edit-copy-symbolic' --transient 'Updated clipboard' "$result"
        else
          ${getExe' libnotify "notify-send"} --icon 'dialog-error-symbolic' --transient 'Failed to updated clipboard' 'Not an issue URL'
        fi
      '';
    };

    # Configuration
    home.sessionVariables = {
      ANSIBLE_NOCOWS = "🐄"; # Workaround for ansible/ansible#10530
      PYTHON_KEYRING_BACKEND = "keyring.backends.fail.Keyring"; # Workaround for python-poetry/poetry#8761
      UV_PYTHON_DOWNLOADS = "never";
    };
    xdg.configFile."autostart/com.tomjwatson.Emote.desktop".source = "${pkgs.emote}/share/applications/com.tomjwatson.Emote.desktop";
    xdg.configFile."cargo-release/release.toml".source = writeTOML "release.toml" {
      push = false;
      publish = false;
      pre-release-commit-message = "Version {{version}}";
      tag-message = "Version {{version}}";
    };
    home.file.".npmrc".text = toKeyValue { } { fund = false; update-notifier = false; };
    xdg.configFile."rustfmt/rustfmt.toml".source = writeTOML "rustfmt.toml" {
      condense_wildcard_suffixes = true;
      # error_on_unformatted = true; # Pending rust-lang/rustfmt#3392
      use_field_init_shorthand = true;
      use_try_shorthand = true;
    };
    home.file.".shellcheckrc".text = "disable=SC1111";
    home.file.".ssh/config.d/.keep".text = "";
    dconf.settings."org/gnome/gnome-system-monitor" = with palette.hex; {
      cpu-colors = imap0 (i: c: mkTuple [ (mkUint32 i) c ]) (
        {
          "4" = [ red orange green blue ];
          "6" = [ red orange yellow green blue purple ];
          "8" = [ red vermilion orange yellow green teal blue purple ];
          "12" = [ red red-dim orange orange-dim yellow yellow-dim green green-dim blue blue-dim purple purple-dim ];
          "16" = [ red red-dim vermilion vermilion-dim orange orange-dim yellow yellow-dim green green-dim teal teal-dim blue blue-dim purple purple-dim ];
        }."${toString host.cores}"
      );
      mem-color = orange;
      swap-color = purple;
      net-in-color = blue;
      net-out-color = red;
    };
    home.file.".vagrant.d/Vagrantfile".text =
      let ip = "192.168.56.1" /* networking.interfaces.vboxnet0 */; in ''
        Vagrant.configure('2') do |config|
          config.vm.provision :shell, name: 'APT cache', inline: <<~BASH
            if [[ -d '/etc/apt' ]]; then
              tee '/etc/apt/apt.conf.d/02cache' <<APT
            Acquire::http::Proxy "http://${ip}:3142";
            Acquire::https::Proxy "false";
            APT
            fi
          BASH
        end
      '';
    xdg.configFile."gopass/config".text = toINI { } config.programs.gopass.settings;
    xdg.configFile."watchlog/config.scfg".text = ''
      delay: 1m
      permanent-delay: never
    '';
  };
}
