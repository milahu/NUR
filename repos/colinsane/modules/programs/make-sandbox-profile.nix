{ lib
, writeTextFile }:

{ pkgName
, method
, allowedPaths ? []
, symlinkCache ? {}
, autodetectCliPaths ? false
, capabilities ? []
, dns ? null
, netDev ? null
, whitelistPwd ? false
, extraConfig ? []
}:
let
  allowPath = p: [
    "--sane-sandbox-path"
    p
  ];
  allowPaths = paths: lib.flatten (builtins.map allowPath paths);

  cacheLink = from: to: [
    "--sane-sandbox-cache-symlink"
    from
    to
  ];
  cacheLinks = links: lib.flatten (lib.mapAttrsToList cacheLink links);

  capabilityFlags = lib.flatten (builtins.map (c: [ "--sane-sandbox-cap" c ]) capabilities);

  netItems = lib.optionals (netDev != null) [
    "--sane-sandbox-net"
    netDev
  ] ++ lib.optionals (dns != null) (
    lib.flatten (builtins.map
      (addr: [ "--sane-sandbox-dns" addr ])
      dns
    )
  );

  sandboxFlags = [
    "--sane-sandbox-method" method
  ]
    ++ netItems
    ++ allowPaths allowedPaths
    ++ capabilityFlags
    ++ lib.optionals (autodetectCliPaths != null) [ "--sane-sandbox-autodetect" autodetectCliPaths ]
    ++ lib.optionals whitelistPwd [ "--sane-sandbox-add-pwd" ]
    ++ cacheLinks symlinkCache
    ++ extraConfig;

in
  writeTextFile {
    name = "${pkgName}-sandbox-profiles";
    destination = "/share/sane-sandboxed/profiles/${pkgName}.profile";
    text = builtins.concatStringsSep "\n" sandboxFlags;
  }
