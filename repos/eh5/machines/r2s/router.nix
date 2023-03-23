{ config, pkgs, lib, ... }: {
  networking.nftables = {
    enable = true;
    checkRuleset = false;
    rulesetFile = ./files/nftables.nft;
  };
  networking.enableNftablesFullcone = true;

  services.resolved.enable = false;
  services.dnsmasq = {
    enable = true;
    settings = {
      no-resolv = true;
      server = [ "127.0.0.1#5333" ];
      local = "/lan/";
      interface = "intern0";
      bind-interfaces = true;
      expand-hosts = true;
      domain = "lan";
      dhcp-range = "192.168.1.3,192.168.1.255,255.255.255.0,24h";
      cache-size = 0;
      no-negcache = true;
    };
  };

  services.v2ray-rules-dat = {
    enable = true;
    dates = "6:30";
    randomizedDelaySec = "30min";
  };

  # slient redis
  boot.kernel.sysctl."vm.overcommit_memory" = 1;

  services.mosdns = {
    enable = true;
    configFile = config.sops.secrets.mosdnsConfig.path;
  };
  systemd.services.mosdns = {
    preStart = ''
      mkdir -p /var/lib/mosdns
    '';
  };

  sops.secrets.mosdnsConfig.restartUnits = [ "mosdns.service" ];
  services.v2ray-rules-dat.reloadServices = [ "mosdns.service" ];
}
