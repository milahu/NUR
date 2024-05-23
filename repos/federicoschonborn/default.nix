# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:

pkgs.lib.makeScope pkgs.newScope (self: {
  biplanes-revival = self.callPackage ./pkgs/biplanes-revival { };
  brisk-menu = self.callPackage ./pkgs/brisk-menu { };
  bsdutils = self.callPackage ./pkgs/bsdutils { };
  cargo-aoc = self.callPackage ./pkgs/cargo-aoc { };
  fastfetch = self.callPackage ./pkgs/fastfetch { };
  firefox-gnome-theme = self.callPackage ./pkgs/firefox-gnome-theme { };
  flyaway = self.callPackage ./pkgs/flyaway { };
  gtatool = self.callPackage ./pkgs/gtatool { };
  inko = self.callPackage ./pkgs/inko { };
  kuroko = self.callPackage ./pkgs/kuroko { };
  kiview = if pkgs ? kdePackages then self.callPackage ./pkgs/kiview { } else null;
  libgta = self.callPackage ./pkgs/libgta { };
  libtgd = self.callPackage ./pkgs/libtgd { };
  libxo = self.callPackage ./pkgs/libxo { };
  magpie-wayland = self.callPackage ./pkgs/magpie-wayland { };
  mii-emu = self.callPackage ./pkgs/mii-emu { };
  minesector = self.callPackage ./pkgs/minesector { };
  mucalc = self.callPackage ./pkgs/mucalc { };
  opensurge = self.callPackage ./pkgs/opensurge { };
  plasma-camera = self.callPackage ./pkgs/plasma-camera { };
  pseint = self.callPackage ./pkgs/pseint { };
  qv = self.callPackage ./pkgs/qv { };
  raze = self.callPackage ./pkgs/raze { };
  srb2p = self.callPackage ./pkgs/srb2p { };
  supermodel = self.callPackage ./pkgs/supermodel { };
  surgescript = self.callPackage ./pkgs/surgescript { };
  teem = self.callPackage ./pkgs/teem { };
  thunderbird-gnome-theme = self.callPackage ./pkgs/thunderbird-gnome-theme { };
  unnamed-sdvx-clone = self.callPackage ./pkgs/unnamed-sdvx-clone { };
  wisp = self.callPackage ./pkgs/wisp { };

  # Backports
  wlroots_0_17 = pkgs.wlroots.overrideAttrs (prevAttrs: {
    version = "0.17.2";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "6dce6ae2ed92544b9758b194618e21f4c97f1d6b";
      hash = "sha256-Of9qykyVnBURc5A2pvCMm7sLbnuuG7OPWLxodQLN2Xg=";
    };
    buildInputs = (prevAttrs.buildInputs or [ ]) ++ [
      pkgs.hwdata
      pkgs.libdisplay-info
    ];
  });

  yyjson_0_9 = pkgs.yyjson.overrideAttrs (
    finalAttrs: _: {
      version = "0.9.0";
      src = pkgs.fetchFromGitHub {
        owner = "ibireme";
        repo = "yyjson";
        rev = finalAttrs.version;
        hash = "sha256-iRMjiaVnsTclcdzHjlFOTmJvX3VP4omJLC8AWA/EOZk=";
      };
    }
  );

  # Variants
  fastfetchMinimal =
    (self.fastfetch.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-minimal";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with all features disabled)";
        mainProgram = "fastfetch";
      };
    })).override
      {
        enableVulkan = false;
        enableWayland = false;
        enableXcb = false;
        enableXcbRandr = false;
        enableXrandr = false;
        enableX11 = false;
        enableDrm = false;
        enableGio = false;
        enableDconf = false;
        enableDbus = false;
        enableXfconf = false;
        enableSqlite3 = false;
        enableRpm = false;
        enableImagemagick7 = false;
        enableChafa = false;
        enableZlib = false;
        enableEgl = false;
        enableGlx = false;
        enableOsmesa = false;
        enableOpencl = false;
        enableLibnm = false;
        enableFreetype = false;
        enablePulse = false;
        enableDdcutil = false;
        enableDirectxHeaders = false;
        enableProprietaryGpuDriverApi = false;
      };

  gtatoolFull =
    (self.gtatool.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-full";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with all features enabled)";
      };
    })).override
      {
        # Broken
        withBashCompletion = false;
        withDcmtk = true;
        # Needs patching
        withExr = false;
        # Needs patching
        withFfmpeg = false;
        withGdal = true;
        withJpeg = true;
        # ImageMagick 6 is marked as insecure
        withMagick = false;
        withMatio = true;
        withMuparser = true;
        withNetcdf = true;
        withNetpbm = true;
        withPcl = true;
        # Requires ImageMagick 6
        withPfs = false;
        withPng = true;
        # Needs patching
        withQt = false;
        withSndfile = true;
        withTeem = true;
      };

  libtgdFull =
    (self.libtgd.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-full";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with all features enabled)";
      };
    })).override
      {
        withTool = true;
        withDocs = true;
        withCfitsio = true;
        withDmctk = true;
        # Broken
        withExiv2 = false;
        withFfmpeg = true;
        withGdal = true;
        withGta = true;
        withHdf5 = true;
        withJpeg = true;
        # ImageMagick 6 is marked as insecure
        withMagick = false;
        withMatio = true;
        withMuparser = true;
        withOpenexr = true;
        # Requires ImageMagick 6
        withPfs = false;
        withPng = true;
        withPoppler = true;
        withTiff = true;
      };

  razeFull =
    (self.raze.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-full";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with all features enabled)";
      };
    })).override
      { withGtk3 = true; };

  teemFull =
    (self.teem.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-full";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with all features enabled)";
      };
    })).override
      {
        withBzip2 = true;
        withPthread = true;
        withFftw3 = true;
        withLevmar = true;
        withPng = true;
        withZlib = true;
      };

  teemExperimental =
    (self.teem.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-experimental";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with experimental libraries and applications enabled)";
      };
    })).override
      {
        withExperimentalApps = true;
        withExperimentalLibs = true;
      };

  teemExperimentalFull =
    (self.teem.overrideAttrs (prevAttrs: {
      pname = "${prevAttrs.pname}-experimental-full";
      meta = prevAttrs.meta // {
        description = "${prevAttrs.meta.description} (with experimental libraries and applications, and all features enabled)";
      };
    })).override
      {
        withExperimentalApps = true;
        withExperimentalLibs = true;
        withBzip2 = true;
        withPthread = true;
        withFftw3 = true;
        withLevmar = true;
        withPng = true;
        withZlib = true;
      };
})
