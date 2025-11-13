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
  rev = "c9c1eebc48354beca41ad8a3d66ad15fd06f0a8c";
  sha256 = "sha256-WquMfJDTsBCCLS4Xg1HASLORiNBHu2VQ44zBeSyIvYs=";
  version = "unstable-2025-11-12";
  branch = "master";
}
