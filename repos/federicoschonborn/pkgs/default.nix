{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  (lib.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    directory = ./by-name;
  })
  // {
    # Sets
    akkoma-emoji = pkgs.recurseIntoAttrs (pkgs.callPackage ./akkoma-emoji { });

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
  }
)
