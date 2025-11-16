# to fix sha256 (in case the updater glitches):
# - delete `sha256` or set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got: sha256-xyz`
# - past that hash back into the `sha256` field
#
# if that fails, then:
# - set `sha256 = "";`
# - nix-build -A hello
#   => it will fail, `hash mismatch ... got:  sha256:xyz`
# - nix hash to-sri sha256:xyz
#   - paste the output as the new `sha256`
{
  mkNixpkgs ? import ./mkNixpkgs.nix {},
}:
mkNixpkgs {
  rev = "0a773851e24f64622f6493aa5ed3ff37609232a2";
  sha256 = "sha256-VjTRXWhwE2b28jNKbarVv5jTlSRc5GmiMudeGas9BSQ=";
  version = "unstable-2025-11-15";
  branch = "master";
}
