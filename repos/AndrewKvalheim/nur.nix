{ pkgs }:

let
  # Build fails with “packaging<25.0,>=24.0 not satisfied by version 25.0”
  brokenMeshtastic = attrs: {
    meta = attrs.meta // {
      broken = pkgs.lib.versionAtLeast pkgs.python3Packages.packaging.version "25"
        && pkgs.python3Packages.meshtastic.version == "2.6.3";
    };
  };
in
# Published as nur.repos.AndrewKvalheim (https://nur.nix-community.org/repos/andrewkvalheim/)
rec {
  hmModules = {
    nixpkgs-issue-55674 = import ./packages/nixpkgs-issue-55674.nix;
    xcompose = import ./packages/xcompose.nix;
  };

  modules = {
    nixpkgs-issue-55674 = import ./packages/nixpkgs-issue-55674.nix;
    nixpkgs-issue-163080 = import ./packages/nixpkgs-issue-163080.nix;
  };

  lib = {
    inherit (import ./common/resources/lib.nix { inherit (pkgs) lib; })
      chebyshev
      chebyshevWithDomain
      contrastRatio
      linearRgbToRgb
      oklchToCss
      oklchToLinearRgb
      rgbToHex
      sgr;
  };

  apex = pkgs.callPackage ./packages/apex.nix { };
  blocky-ui = pkgs.callPackage ./packages/blocky-ui.nix { };
  buildJosmPlugin = pkgs.callPackage ./packages/buildJosmPlugin.nix { };
  cavif = pkgs.callPackage ./packages/cavif.nix { };
  ch57x-keyboard-tool = pkgs.callPackage ./packages/ch57x-keyboard-tool.nix { };
  co2monitor = pkgs.callPackage ./packages/co2monitor.nix { };
  decompiler-mc = pkgs.callPackage ./packages/decompiler-mc.nix { };
  dmarc-report-notifier = (pkgs.callPackage ./packages/dmarc-report-notifier.nix {
    python3Packages = (pkgs.python3.override {
      packageOverrides = _: pythonPackages: {
        # Pending NixOS/nixpkgs#337081
        msgraph-core = pkgs.lib.warnIfNot pkgs.python3Packages.parsedmarc.meta.broken "python3Packages.parsedmarc is no longer broken"
          (pkgs.lib.findFirst (p: p.pname == "msgraph-core") null pkgs.parsedmarc.requiredPythonModules);
      };
    }).pkgs;
  });
  fastnbt-tools = pkgs.callPackage ./packages/fastnbt-tools.nix { };
  fediblockhole = pkgs.callPackage ./packages/fediblockhole.nix { };
  git-diff-image = pkgs.callPackage ./packages/git-diff-image.nix { };
  gpx-reduce = pkgs.callPackage ./packages/gpx-reduce.nix { };
  iptables_exporter = pkgs.callPackage ./packages/iptables_exporter.nix { };
  josm-imagery-used = pkgs.callPackage ./packages/josm-imagery-used.nix { inherit buildJosmPlugin; };
  little-a-map = pkgs.callPackage ./packages/little-a-map.nix { };
  mark-applier = pkgs.callPackage ./packages/mark-applier.nix { };
  meshtastic-url = (pkgs.callPackage ./packages/meshtastic-url.nix { }).overrideAttrs brokenMeshtastic;
  minemap = pkgs.callPackage ./packages/minemap.nix { };
  mqtt-connect = (pkgs.callPackage ./packages/mqtt-connect.nix { }).overrideAttrs brokenMeshtastic;
  mqtt-protobuf-to-json = (pkgs.callPackage ./packages/mqtt-protobuf-to-json.nix { }).overrideAttrs brokenMeshtastic;
  nbt-explorer = pkgs.callPackage ./packages/nbt-explorer.nix { };
  pngquant-interactive = pkgs.callPackage ./packages/pngquant-interactive.nix { };
  spf-check = pkgs.callPackage ./packages/spf-check.nix { };
  spf-tree = pkgs.callPackage ./packages/spf-tree.nix { };
  tile-stitch = pkgs.callPackage ./packages/tile-stitch.nix { };
  wireguard-vanity-address = pkgs.callPackage ./packages/wireguard-vanity-address.nix { };
  zsh-completion-sync = pkgs.callPackage ./packages/zsh-completion-sync.nix { };
}
