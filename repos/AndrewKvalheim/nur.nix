{ pkgs }:

let
  inherit (lib) findFirst recursiveUpdate versionOlder warnIfNot;
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
      sgr;
  };

  apex = callPackage ./library/apex.pkg.nix { };
  blocky-ui = callPackage ./library/blocky-ui.pkg.nix { };
  buildJosmPlugin = callPackage ./library/buildJosmPlugin.fn.nix { };
  busyserve = (callPackage ./library/busyserve.pkg.nix { });
  caddy-with-route53 = (pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/route53@v1.6.0" ];
    hash = "sha256-C2Lw70hze+nCKX4qPl1JCm/wcD7hNP2imCrTtkkj8U8=";
  }).overrideAttrs (c: recursiveUpdate c { meta.broken = versionOlder pkgs.go.version "1.25.5"; /* Pending NixOS/nixpkgs#467201 */ });
  cavif = callPackage ./library/cavif.pkg.nix { };
  ch57x-keyboard-tool = callPackage ./library/ch57x-keyboard-tool.pkg.nix { };
  co2monitor = callPackage ./library/co2monitor.pkg.nix { };
  decompiler-mc = callPackage ./library/decompiler-mc.pkg.nix { };
  dmarc-report-notifier = callPackage ./library/dmarc-report-notifier.pkg.nix {
    python3Packages = (pkgs.python3.override {
      packageOverrides = _: pythonPackages: {
        # Pending NixOS/nixpkgs#337081
        msgraph-core = warnIfNot pkgs.python3Packages.parsedmarc.meta.broken "python3Packages.parsedmarc is no longer broken"
          (findFirst (p: p.pname == "msgraph-core") null pkgs.parsedmarc.requiredPythonModules);
      };
    }).pkgs;
  };
  fastnbt-tools = callPackage ./library/fastnbt-tools.pkg.nix { };
  fediblockhole = callPackage ./library/fediblockhole.pkg.nix { };
  git-diff-image = callPackage ./library/git-diff-image.pkg.nix { };
  gpx-reduce = callPackage ./library/gpx-reduce.pkg.nix { };
  iptables_exporter = callPackage ./library/iptables_exporter.pkg.nix { };
  josm-imagery-used = callPackage ./library/josm-imagery-used.pkg.nix { inherit buildJosmPlugin; };
  little-a-map = callPackage ./library/little-a-map.pkg.nix { };
  mark-applier = callPackage ./library/mark-applier.pkg.nix { };
  meshtastic-url = callPackage ./library/meshtastic-url.pkg.nix { };
  minemap = callPackage ./library/minemap.pkg.nix { };
  nbt-explorer = callPackage ./library/nbt-explorer.pkg.nix { };
  pdfalyzer = callPackage ./library/pdfalyzer.pkg.nix { };
  pngquant-interactive = callPackage ./library/pngquant-interactive.pkg.nix { };
  spf-check = callPackage ./library/spf-check.pkg.nix { };
  spf-tree = callPackage ./library/spf-tree.pkg.nix { };
  starship-jj = callPackage ./library/starship-jj.pkg.nix { };
  stretch-break = callPackage ./library/stretch-break.pkg.nix { };
  tile-stitch = callPackage ./library/tile-stitch.pkg.nix { };
  wireguard-vanity-address = callPackage ./library/wireguard-vanity-address.pkg.nix { };
}
