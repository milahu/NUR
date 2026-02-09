# the output of this file is the `sane` scope:
# - a set of packages which _do not intersect_ with nixpkgs pkgs.
#   i.e. it contains _only_ the packages unique to this repo.
#   - this way it should make sense to run every update script within here.
#
# this can be used as an overlay, via the `packages` output:
# ```nix
# saneOverlay = final: prev:
#   let
#     sane = import ./pkgs { pkgs = prev; };
#   in
#     sane.packages final;
# ```
#
# however that only overlays strictly _new_ packages;
# to properly merge package sets like `mpvScripts`, use `sanePkgsOverlay`:
# ```nix
# saneOverlay = final: prev:
#  let
#    sane = import ./pkgs { pkgs = prev; };
#  in
#    sane.sanePkgsOverlay final prev;
# ```
# but note that propagating an entire `mpvScripts` package set, despite only
# 1-2 of those being original packages, isn't suitable for consumers like NUR.
{ pkgs }:
pkgs.lib.makeScope pkgs.newScope (self:
let
  byName = pkgs.lib.filesystem.packagesFromDirectoryRecursive {
    inherit (self) callPackage;
    # inherit (self) makeScope;  #< this breaks splicing? e.g. `pkgsCross.aarch64-multiplatform.docsets.rust-std`
    directory = ./by-name;
  };
  byName' = removeAttrs byName [
    # `packagesFromDirectoryRecursive` adds these even though we (hopefully??) didn't create
    # a new scope for it.
    "callPackage"
    "newScope"
    "packages"
    "recurseForDerivations"
  ];
  newToplevels = byName' // {
    ## aliases
    inherit (self.trivial-builders)
      copyIntoOwnPackage
      deepLinkIntoOwnPackage
      linkBinIntoOwnPackage
      linkIntoOwnPackage
      rmDbusServices
      rmDbusServicesInPlace
      runCommandLocalOverridable
      runCommandLocalOverridable'
      writeSymlink
      writeSymlinkFile
    ;

    ## conveniences for external consumers; not used by my own pkgs or nixos config
    # convenience for building packages with `strictDeps = true` _everywhere_.
    # out for PR: <https://github.com/NixOS/nixpkgs/pull/481485>
    pkgsStrict = import "${pkgs.path}/pkgs/top-level" {
      inherit (self)
        # crossOverlays
        # crossSystem
        # localSystem
        overlays
      ;
      localSystem = self.stdenv.buildPlatform.system;
      config = self.config // {
        strictDepsByDefault = true;
      };
    };

    ### FIREFOX EXTENSIONS
    # build like `nix-build -A firefox-extensions.default-zoom`.
    # doesn't *need* to be its own scope, but this style of organization makes it easier to track.
    firefox-extensions = pkgs.lib.filesystem.packagesFromDirectoryRecursive {
      inherit (self) callPackage newScope;
      directory = ./firefox-extensions;
    };

    ### OLLAMA PACKAGES (i.e. Large Language Models)
    # build like `nix-build -A ollamaPackages.deepseek-r1-1_5b`
    ollamaPackages = pkgs.lib.filesystem.packagesFromDirectoryRecursive {
      inherit (self) callPackage newScope;
      directory = ./ollamaPackages;
    };


    ### ADDITIONAL MPV SCRIPTS
    # build like:
    # - `nix-build -A saneMpvScripts.sane_cast`
    # - `nix-build -A mpvScripts.sane_cast`
    saneMpvScriptsExtension = mFinal: mPrev:
      pkgs.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (mFinal) callPackage;
        directory = ./mpv-scripts;
      };

    saneMpvScripts =
    let
      mpvScripts = pkgs.mpvScripts.overrideScope self.saneMpvScriptsExtension;
    in
      self.saneMpvScriptsExtension mpvScripts pkgs.mpvScripts;


    ### ADDITIONAL KERNEL PACKAGES
    # build like:
    # - `nix-build -A saneKernelPackages.rk818-charger`
    # - `nix-build -A linuxPackages.rk818-charger`
    # - `nix-build -A hosts.moby.config.boot.kernelPackages.rk818-charger`
    saneKernelPackagesExtension = kFinal: kPrev:
      pkgs.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (kFinal) callPackage;
          directory = ./linux-packages;
      };

    saneKernelPackages =
    let
      linuxPackages = pkgs.linuxPackages.extend self.saneKernelPackagesExtension;
    in
      self.saneKernelPackagesExtension linuxPackages pkgs.linuxPackages;


    ### OVERLAY PASSTHRU
    # the default `sane` package set does not extend any nixpkgs' pkgs sets,
    # so as to avoid propagating packages it didn't explicitly define.
    #
    # to merge `sane` packages into the places they belong (e.g. mpvScripts, linuxPackages),
    # apply this overlay.
    sanePkgsOverlay = final: prev:
    let
      sane = import ./. { pkgs = prev; };
      saneOverNixpkgs = sane.overrideScope (saneFinal: sanePrev: {
        mpvScripts = prev.mpvScripts.overrideScope (mpvFinal: mpvPrev:
          saneFinal.saneMpvScriptsExtension mpvFinal mpvPrev
        );

        kernelPackagesExtensions = prev.kernelPackagesExtensions ++ [
          saneFinal.saneKernelPackagesExtension
        ];
      });
    in
      (saneOverNixpkgs.packages final);
  };
in
  # TODO: bring back this shadowing warning, but it causes false positives with `sane` scope right now.
  # builtins.mapAttrs (k: v: pkgs.lib.warnIf (pkgs ? "${k}") "nixpkgs ${k} is shadowed by in-tree ${k}" v) newToplevels
  newToplevels
)
