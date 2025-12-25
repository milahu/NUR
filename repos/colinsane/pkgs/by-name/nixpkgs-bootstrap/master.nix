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
  rev = "7bd4e483ed6db0b7f40ce44b688ad4d6f9ce0909";
  sha256 = "sha256-h0dokVD5fQm6QvImau7hkiYqdVX7PBsgXs/uzd52KBw=";
  version = "unstable-2025-12-24";
  branch = "master";
}
