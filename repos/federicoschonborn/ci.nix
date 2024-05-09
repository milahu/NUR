# This file provides all the buildable and cacheable packages and
# package outputs in your package set. These are what gets built by CI,
# so if you correctly mark packages as
#
# - broken (using `meta.broken`),
# - unfree (using `meta.license.free`), and
# - locally built (using `preferLocalBuild`)
#
# then your CI will be able to build and cache only those packages for
# which this is possible.

{
  pkgs ? import <nixpkgs> { },
}:

let
  isReserved = n: n == "lib" || n == "overlays" || n == "modules";
  isDerivation = p: builtins.isAttrs p && p ? type && p.type == "derivation";
  isBuildable = p: !(p.meta.broken or false) && p.meta.license.free or true;
  isCacheable = p: !(p.preferLocalBuild or false);
  shouldRecurseForDerivations = p: builtins.isAttrs p && p.recurseForDerivations or false;

  nameValuePair = n: v: {
    name = n;
    value = v;
  };

  concatMap = builtins.concatMap or (f: xs: builtins.concatLists (builtins.map f xs));

  flattenPkgs =
    s:
    let
      f =
        p:
        if shouldRecurseForDerivations p then
          flattenPkgs p
        else if isDerivation p then
          [ p ]
        else
          [ ];
    in
    concatMap f (builtins.attrValues s);

  outputsOf = p: builtins.map (o: p.${o}) p.outputs;

  nurAttrs = import ./default.nix { inherit pkgs; };

  nurPkgs = flattenPkgs (
    builtins.listToAttrs (
      builtins.map (n: nameValuePair n nurAttrs.${n}) (
        builtins.filter (n: !isReserved n) (builtins.attrNames nurAttrs)
      )
    )
  );

  buildPkgs = builtins.filter isBuildable nurPkgs;
  cachePkgs = builtins.filter isCacheable buildPkgs;

  buildOutputs = concatMap outputsOf buildPkgs;
  cacheOutputs = concatMap outputsOf cachePkgs;
in

{
  inherit
    buildPkgs
    cachePkgs
    buildOutputs
    cacheOutputs
    ;
}
