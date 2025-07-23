{
  pkgs,
  config,
  lib,
  vacuModuleType,
  ...
}:
let
  enableFfmpeg = !config.vacu.isMinimal;
  enableFfmpegFull = enableFfmpeg && config.vacu.isGui;
  enableFfmpegHeadless = enableFfmpeg && !config.vacu.isGui;
  winePkgs = pkgs.wineWow64Packages;
in
{
  vacu.packages = lib.mkMerge [
    {
      borgbackup.enable = config.vacu.isDev && (pkgs.system != "aarch64-linux"); # borgbackup build is borken on aarch64
      ffmpeg-vacu-full = {
        enable = enableFfmpegFull;
        package = pkgs.ffmpeg-full;
        overrides.libbluray = config.vacu.packages.libbluray-all.finalPackage;
      };
      ffmpeg-vacu-headless = {
        enable = enableFfmpegHeadless;
        package = pkgs.ffmpeg-headless;
        overrides.libbluray = config.vacu.packages.libbluray-all.finalPackage;
      };
      libbluray-all = {
        package = pkgs.libbluray;
        overrides = {
          withJava = true;
          withAACS = true;
          withBDplus = true;
        };
      };
      inkscape-all = {
        package = pkgs.inkscape-with-extensions;
        # null actually means everything https://github.com/NixOS/nixpkgs/commit/5efd65b2d94b0ac0cf155e013b6747fa22bc04c3
        overrides.inkscapeExtensions = null;
      };
      p7zip-unfree = {
        package = pkgs.p7zip;
        overrides.enableUnfree = true;
      };
      wine.package = winePkgs.waylandFull;
      wine-fonts.package = winePkgs.fonts;
      vacu-units.package = config.vacu.units.finalPackage;
    }
    (lib.mkIf config.vacu.isGui
      # just do all the matrix clients, surely one of them will work enough
      ''
        cinny-desktop
        element-call
        element-desktop
        fluffychat
        fractal
        gomuks
        gomuks-web
        # hydrogen has no -desktop version
        iamb
        kazv
        matrix-commander
        matrix-commander-rs
        matrix-dl
        mm
        neosay
        nheko
        pinecone
        # quaternion # build is borked
      ''
    )
    (lib.mkIf config.vacu.isGui
      # pkgs for systems with a desktop GUI
      ''
        acpi
        anki
        audacity
        arduino-ide
        bitwarden-desktop
        brave
        dino
        filezilla
        gamemode
        ghidra
        gimp
        haruna
        iio-sensor-proxy
        inkscape-all
        jellyfin-media-player
        josm
        kdePackages.elisa
        kdePackages.kdenlive
        libreoffice-qt6-fresh
        # librewolf
        linphone
        merkaartor
        nextcloud-client
        obsidian
        openscad
        openshot-qt
        orca-slicer
        OSCAR
        prismlauncher
        shotcut
        signal-desktop
        svp
        thunderbird
        tremotesf
        ungoogled-chromium
        vlc
        wayland-utils
        wev
        wine
        wine-fonts
        wireshark
        wl-clipboard
      ''
    )
    # pkgs for development-ish
    (lib.mkIf config.vacu.isDev ''
      cargo
      clippy
      gnumake
      man-pages
      patchelf
      python3
      ruby
      rustc
      rust-script
      shellcheck
      stdenv.cc
    '')
    (lib.mkIf (!config.vacu.isMinimal)
      # big pkgs for non-minimal systems
      ''
        aircrack-ng
        android-tools
        bitwarden-cli
        dmidecode
        fido2-manage
        flac
        hdparm
        home-manager
        imagemagickBig
        kanidm_1_6
        libsmi
        man
        megatools
        mercurial #aka hg
        minicom
        mkvtoolnix-cli
        # neovim => see common/nixvim.nix
        net-snmp
        nix-index
        nix-inspect
        nix-search-cli
        nix-tree
        nmap
        nvme-cli
        proxmark3
        rclone
        ripgrep-all
        smartmontools
        tcpdump
        termscp
        tshark
        yt-dlp
      ''
    )
    # pkgs included everywhere
    ''
      altcaps
      ddrescue
      dig
      dnsutils
      ethtool
      file
      # git is handled by common/git.nix
      gnutls
      gptfdisk
      hostname
      htop
      inetutils
      iperf3
      iputils
      jq
      jujutsu
      killall
      libossp_uuid # provides `uuid` binary
      linuxquota
      lsof
      mosh
      nano
      ncdu
      netcat-openbsd
      nixos-rebuild
      p7zip-unfree
      pciutils
      progress
      psutils
      pv
      ripgrep
      rsync
      screen
      # sed => gnused
      shellvaculib
      # sops => should use `nr vacu#sops` instead
      sshfs
      ssh-to-age
      # tar => gnutar
      tmux
      tree
      tzdata
      # units => vacu-units
      unzip
      usbutils
      vacu-units
      vim
      wget
      zip
    ''
    # packages that are in [`requiredPackages`][1]  in nixos, but maybe not included in nix-on-droid
    # [1]: https://github.com/NixOS/nixpkgs/blob/26d499fc9f1d567283d5d56fcf367edd815dba1d/nixos/modules/config/system-path.nix#L11
    (lib.optionalAttrs (vacuModuleType == "nix-on-droid") ''
      #stdenv.cc.libc shouldn't be needed right?
      acl
      attr
      bashInteractive
      bzip2
      cpio
      curl
      diffutils
      findutils
      gawk
      getent
      getconf
      gnugrep
      gnupatch
      gnused
      gnutar
      gzip
      less
      libcap
      mkpasswd
      ncurses
      #netcat is replaced by netcat-openbsd
      openssh
      procps
      su
      time
      util-linux
      which
      xz
      zstd
    '')
  ];
}
