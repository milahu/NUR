lib: self: super:

### Deprecated aliases - for backward compatibility
### Please maintain this list in ASCIIbetical ordering.
### Hint: the "sections" are delimited by ### <letter> ###

# These aliases should not be used within nixpkgs, but exist to improve
# backward compatibility in projects outside of nixpkgs. See the
# documentation for the `allowAliases` option for more background.

# A script to convert old aliases to throws and remove old
# throws can be found in './maintainers/scripts/remove-old-aliases.py'.

# Add 'preserve, reason: reason why' after the date if the alias should not be removed.
# Try to keep them to a minimum.
# valid examples of what to preserve:
#   distro aliases such as:
#     debian-package-name -> nixos-package-name

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false
    then removeAttrs alias [ "recurseForDerivations" ]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from all-packages.nix.
  checkInPkgs = n: alias:
    if builtins.hasAttr n super
    then throw "Alias ${n} is still in all-packages.nix"
    else alias;

  mapAliases = aliases:
    lib.mapAttrs
      (n: alias:
        removeDistribute
          (removeRecurseForDerivations
            (checkInPkgs n alias)))
      aliases;
in

mapAliases ({

  #adtool = throw "'adtool' has been removed, as it was broken and unmaintained";
  #alsaLib = alsa-lib; # Added 2021-06-09
  #gnatsd = throw "'gnatsd' has been renamed to/replaced by 'nats-server'"; # Converted to throw 2023-09-10

})
