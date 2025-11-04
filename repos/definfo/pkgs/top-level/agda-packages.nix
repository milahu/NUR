{
  # config,
  lib,
  newScope,
  Aya,
}:
let
  mkAyaPackages = Aya: lib.makeScope newScope (mkAyaPackages' Aya);
  mkAyaPackages' =
    Aya: self:
    let
      inherit (self) callPackage;
      inherit
        (callPackage ../build-support/aya {
          inherit Aya self;
        })
        withPackages
        mkDerivation
        ;
    in
    rec {
      inherit mkDerivation;

      standard-library = callPackage ../development/libraries/aya/standard-library { };

      # Include in-tree standard library by default
      aya = withPackages [ standard-library ];
      aya-minimal = withPackages [ ];
    };
in
mkAyaPackages Aya
