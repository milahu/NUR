{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    util-linux
    htop
    silver-searcher
    fzf
    apg
    glow
    smug
    ctags
    cheat
    git-lfs
    sc-im
    jq
    yj
    imagemagick
    python3Full
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.requests
    openssl
    direnv
    zip
    unzip
  ]
  ++ (if pkgs.stdenv.isDarwin then
  [
    unixtools.watch
  ]
  else
  [
    sysstat
    iotop
    vifm
    wtf
    binutils
    gettext
    gcc
    ruby
    rake
    bind.dnsutils
    psmisc
    file
    pkg-config
    whois
    xorg.xkill
  ]
  );
}
