# use like `import <nixpkgs> { overlays = ./overlay.nix; }`.
# this cleanly merges my own packages into the nixpkgs namespace,
# e.g. the resulting `pkgs.mpvScripts` contains both nixpkgs' mpvScripts and my own,
# in the same, overridable, scope.
self: super:
let
  sane = import ./unfixed.nix {
    inherit (self) callPackage newScope;
    inherit (super) lib;
    otherSplices = {
      selfBuildBuild = self.pkgsBuildBuild;
      selfBuildHost = self.pkgsBuildHost;
      selfBuildTarget = self.pkgsBuildTarget;
      selfHostHost = self.pkgsHostHost;
      selfHostTarget = self.pkgsHostTarget;
      selfTargetTarget = self.pkgsTargetTarget;
    };
  };
  # these forms below cause infinite recursion but i don't understand why:
  # sane = self.callPackage ./unfixed.nix { inherit (super) lib; };
  # sane = import ./unfixed.nix self;
  # sane = import ./unfixed.nix (self // {
  #   inherit (super) lib;
  # });
in
  removeAttrs sane [
    # nixpkgs generates `linuxPackages` via `kernelPackagesExtensions`:
    # `sane.linuxPackages` is removed here, and re-expressed as an extension, below
    "linuxPackages"
  ] // {
    kernelPackagesExtensions = super.kernelPackagesExtensions ++ [
      (kFinal: _kPrev:
        sane.linuxPackages.packages kFinal
      )
    ];
    mpvScripts = super.mpvScripts.overrideScope (mpvFinal: _mpvPrev:
      sane.mpvScripts.packages mpvFinal
    );
  }
