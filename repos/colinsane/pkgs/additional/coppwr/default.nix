# Cargo.nix and crate-hashes.json were created with:
# - `nix run '.#crate2nix' -- generate -f ~/ref/repos/dimtpap/coppwr/Cargo.toml`
# to update:
# - `git fetch` in `~/ref/repos/dimtpap/coppwr`
# - re-run that crate2nix step
{ pkgs
, defaultCrateOverrides
}:
let
  cargoNix = import ./Cargo.nix {
    inherit defaultCrateOverrides pkgs;
  };
in cargoNix.rootCrate.build
