{ pkgs }:

let
  inherit (lib) findFirst recursiveUpdate versionAtLeast versionOlder warnIf warnIfNot;
  inherit (pkgs) callPackage lib;
in
# Published as nur.repos.AndrewKvalheim (https://nur.nix-community.org/repos/andrewkvalheim/)
rec {
  hmModules = {
    nixpkgs-issue-55674 = import ./library/nixpkgs-issue-55674.user.nix;
    xcompose = import ./library/xcompose.user.nix;
  };

  modules = {
    nixpkgs-issue-55674 = import ./library/nixpkgs-issue-55674.system.nix;
    nixpkgs-issue-163080 = import ./library/nixpkgs-issue-163080.system.nix;
  };

  lib = {
    inherit (import ./library/utilities.lib.nix { inherit (pkgs) lib; })
      chebyshev
      chebyshevWithDomain
      contrastRatio
      linearRgbToRgb
      oklchToCss
      oklchToLinearRgb
      rgbToHex
      sgr
      uniqueBy;
  };

  ai-robots-txt = callPackage ./library/ai-robots-txt.pkg.nix { };
  apex = callPackage ./library/apex.pkg.nix { };
  blocky-ui = callPackage ./library/blocky-ui.pkg.nix { };
  buildJosmPlugin = callPackage ./library/buildJosmPlugin.fn.nix { };
  busyserve = (callPackage ./library/busyserve.pkg.nix { });
  caddy-with-cache-route53 = (pkgs.caddy.withPlugins {
    plugins = [
      "github.com/caddy-dns/route53@v1.6.0"
      "github.com/caddyserver/cache-handler@v0.16.0"
    ];
    hash = "sha256-poxhiFADhdqElcFqUGF0BRhUU3p/+KtrytMaa0DV2Bg=";
  }).overrideAttrs (c: recursiveUpdate c { meta.broken = versionOlder pkgs.go.version "1.25.5"; /* Pending NixOS/nixpkgs#467201 */ });
  cavif = callPackage ./library/cavif.pkg.nix { };
  ch57x-keyboard-tool = callPackage ./library/ch57x-keyboard-tool.pkg.nix { };
  chunker = callPackage ./library/chunker.pkg.nix { };
  co2monitor = callPackage ./library/co2monitor.pkg.nix { };
  decompiler-mc = callPackage ./library/decompiler-mc.pkg.nix { };
  dmarc-report-notifier = callPackage ./library/dmarc-report-notifier.pkg.nix {
    python3Packages = (pkgs.python3.override {
      packageOverrides = _: pythonPackages: {
        # Pending mjs/imapclient#629
        imapclient = warnIf (versionOlder "3.0.1" pythonPackages.imapclient.version) "python3Packages.imapclient no longer requires a version override"
          pythonPackages.imapclient.overrideAttrs
          (imapclient: {
            version = "3.0.1-unstable-2026-01-02";
            src = imapclient.src.override {
              tag = null;
              rev = "f3813a42f5712cf4b8848c823935eabf487ca494";
              hash = "sha256-Yb89xlnrpB3iimJMG4Z5CMLDahqzM/NMk0zi7frw/Vk=";
            };
          });
        # Pending NixOS/nixpkgs#337081
        msgraph-core = warnIfNot pkgs.python3Packages.parsedmarc.meta.broken "python3Packages.parsedmarc is no longer broken"
          (findFirst (p: p.pname == "msgraph-core") null pkgs.parsedmarc.requiredPythonModules);
      };
    }).pkgs;
  };
  easy-timeline = (callPackage ./library/easy-timeline.pkg.nix { }).overrideAttrs (e: recursiveUpdate e {
    meta.broken = versionAtLeast pkgs.stdenv.cc.version "15"; # Ploticus is broken by NixOS/nixpkgs#475479
  });
  fastnbt-tools = callPackage ./library/fastnbt-tools.pkg.nix { };
  fediblockhole = callPackage ./library/fediblockhole.pkg.nix { };
  git-diff-image = callPackage ./library/git-diff-image.pkg.nix { };
  gpx-reduce = callPackage ./library/gpx-reduce.pkg.nix { };
  incremental-compress = callPackage ./library/incremental-compress.pkg.nix { };
  iptables_exporter = callPackage ./library/iptables_exporter.pkg.nix { };
  josm-imagery-used = callPackage ./library/josm-imagery-used.pkg.nix { inherit buildJosmPlugin; };
  journal-brief = callPackage ./library/journal-brief.pkg.nix { };
  little-a-map = callPackage ./library/little-a-map.pkg.nix { };
  mark-applier = callPackage ./library/mark-applier.pkg.nix { };
  meshtastic-url = callPackage ./library/meshtastic-url.pkg.nix { };
  minemap = callPackage ./library/minemap.pkg.nix { };
  nbt-explorer = callPackage ./library/nbt-explorer.pkg.nix { };
  oxvg = callPackage ./library/oxvg.pkg.nix { };
  pdfalyzer = callPackage ./library/pdfalyzer.pkg.nix { };
  pngquant-interactive = callPackage ./library/pngquant-interactive.pkg.nix { };
  spf-check = callPackage ./library/spf-check.pkg.nix { };
  spf-tree = callPackage ./library/spf-tree.pkg.nix { };
  starship-jj = callPackage ./library/starship-jj.pkg.nix { };
  stretch-break = callPackage ./library/stretch-break.pkg.nix { };
  tile-stitch = callPackage ./library/tile-stitch.pkg.nix { };
  wireguard-vanity-address = callPackage ./library/wireguard-vanity-address.pkg.nix { };
}
