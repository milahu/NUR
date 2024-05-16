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
    "--sanebox-path"
    p
  ];
  allowPaths = paths: lib.flatten (builtins.map allowPath paths);

  cacheLink = from: to: [
    "--sanebox-cache-symlink"
    from
    to
  ];
  cacheLinks = links: lib.flatten (lib.mapAttrsToList cacheLink links);

  capabilityFlags = lib.flatten (builtins.map (c: [ "--sanebox-cap" c ]) capabilities);

  netItems = lib.optionals (netDev != null) [
    "--sanebox-net"
    netDev
  ] ++ lib.optionals (dns != null) (
    lib.flatten (builtins.map
      (addr: [ "--sanebox-dns" addr ])
      dns
    )
  );

  sandboxFlags = [
    "--sanebox-method" method
  ]
    ++ netItems
    ++ allowPaths allowedPaths
    ++ capabilityFlags
    ++ lib.optionals (autodetectCliPaths != null) [ "--sanebox-autodetect" autodetectCliPaths ]
    ++ lib.optionals whitelistPwd [ "--sanebox-add-pwd" ]
    ++ cacheLinks symlinkCache
    ++ extraConfig;

in
  writeTextFile {
    name = "${pkgName}-sandbox-profiles";
    destination = "/share/sanebox/profiles/${pkgName}.profile";
    text = builtins.concatStringsSep "\n" sandboxFlags;
  }
