{ pkgs }:

let
  inherit (builtins) any;
  inherit (lib) findFirst versionAtLeast warnIfNot;
  inherit (pkgs) callPackage lib;

  # Dependency broken by NixOS/nixpkgs#431074
  brokenBusylight = attrs: {
    meta = attrs.meta // {
      broken = (versionAtLeast pkgs.python3Packages.busylight-for-humans.version "0.37.0")
        && (any (p: p.pname == "poetry-core") pkgs.python3Packages.busylight-for-humans.build-system);
    };
  };

  # Dependency broken by NixOS/nixpkgs#431074
  brokenMeshtastic = attrs: {
    meta = attrs.meta // {
      broken = (versionAtLeast pkgs.python3Packages.dash.version "3.2.0")
        && ! (any (p: p.pname or null == "psutil") pkgs.python3Packages.dash.nativeBuildInputs);
    };
  };

  # Dependency broken by NixOS/nixpkgs#431074 pending NixOS/nixpkgs#437778
  brokenOpensearchPy = attrs: {
    meta = attrs.meta // {
      broken = pkgs.python3Packages.opensearch-py.version == "3.0.0"
        && versionAtLeast (findFirst (p: p.pname or null == "pytest-asyncio") null pkgs.python3Packages.opensearch-py.nativeBuildInputs).version "1";
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

  apex = callPackage ./packages/apex.nix { };
  blocky-ui = callPackage ./packages/blocky-ui.nix { };
  buildJosmPlugin = callPackage ./packages/buildJosmPlugin.nix { };
  busyserve = (callPackage ./packages/busyserve.nix { }).overridePythonAttrs brokenBusylight;
  cavif = callPackage ./packages/cavif.nix { };
  ch57x-keyboard-tool = callPackage ./packages/ch57x-keyboard-tool.nix { };
  co2monitor = callPackage ./packages/co2monitor.nix { };
  decompiler-mc = callPackage ./packages/decompiler-mc.nix { };
  dmarc-report-notifier = (callPackage ./packages/dmarc-report-notifier.nix {
    python3Packages = (pkgs.python3.override {
      packageOverrides = _: pythonPackages: {
        # Pending NixOS/nixpkgs#337081
        msgraph-core = warnIfNot pkgs.python3Packages.parsedmarc.meta.broken "python3Packages.parsedmarc is no longer broken"
          (findFirst (p: p.pname == "msgraph-core") null pkgs.parsedmarc.requiredPythonModules);
      };
    }).pkgs;
  }).overrideAttrs brokenOpensearchPy;
  fastnbt-tools = callPackage ./packages/fastnbt-tools.nix { };
  fediblockhole = callPackage ./packages/fediblockhole.nix { };
  git-diff-image = callPackage ./packages/git-diff-image.nix { };
  gpx-reduce = callPackage ./packages/gpx-reduce.nix { };
  iptables_exporter = callPackage ./packages/iptables_exporter.nix { };
  josm-imagery-used = callPackage ./packages/josm-imagery-used.nix { inherit buildJosmPlugin; };
  little-a-map = callPackage ./packages/little-a-map.nix { };
  mark-applier = callPackage ./packages/mark-applier.nix { };
  meshtastic-url = (callPackage ./packages/meshtastic-url.nix { }).overrideAttrs brokenMeshtastic;
  minemap = callPackage ./packages/minemap.nix { };
  mqtt-connect = (callPackage ./packages/mqtt-connect.nix { }).overrideAttrs brokenMeshtastic;
  mqtt-protobuf-to-json = (callPackage ./packages/mqtt-protobuf-to-json.nix { }).overrideAttrs brokenMeshtastic;
  nbt-explorer = callPackage ./packages/nbt-explorer.nix { };
  pngquant-interactive = callPackage ./packages/pngquant-interactive.nix { };
  spf-check = callPackage ./packages/spf-check.nix { };
  spf-tree = callPackage ./packages/spf-tree.nix { };
  starship-jj = callPackage ./packages/starship-jj.nix { };
  tile-stitch = callPackage ./packages/tile-stitch.nix { };
  wireguard-vanity-address = callPackage ./packages/wireguard-vanity-address.nix { };
  zsh-completion-sync = callPackage ./packages/zsh-completion-sync.nix { };
}
