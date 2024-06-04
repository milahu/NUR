{ pkgs, ... }:
{
  sane.programs.errno = {
    # packageUnwrapped = pkgs.linkIntoOwnPackage pkgs.moreutils "bin/errno";
    # actually, don't build all of moreutils because not all of it builds for cross targets.
    # some of this can be simplified after <https://github.com/NixOS/nixpkgs/pull/316446>
    packageUnwrapped = pkgs.moreutils.overrideAttrs (base: {
      makeFlags = (base.makeFlags or []) ++ [
        "BINS=errno"
        "MANS=errno.1"
        "PERLSCRIPTS=errno"  #< Makefile errors if empty, but this works :)
        "INSTALL_BIN=install"
      ];
      #v disable the perl-specific stuff
      propagatedBuildInputs = [];
      postInstall = "";
    });

    sandbox.method = "landlock";
  };
}
